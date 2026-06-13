# Audio Pipeline — ThuyVanEnglishApp

Pipeline đầy đủ từ gen audio đến play trên FE.

---

## Tổng quan

**19 câu mẫu** đã có audio chất lượng cao (Google TTS Neural2-F):
- Giọng: `en-US-Neural2-F` (nữ, chuẩn Mỹ)
- Speed: 0.9x (chậm hơn 10% để học sinh dễ nghe)
- Format: MP3, ~20KB/file
- Serve: Static files từ BE (`/audio/*.mp3`)

---

## Workflow

### 1. Gen MP3 từ Google Cloud TTS

**Script:** `/tmp/generate_tts.py`

```python
import requests, base64, os

API_KEY = os.getenv('GOOGLE_TTS_API_KEY')
url = 'https://texttospeech.googleapis.com/v1/text:synthesize'

payload = {
  "input": {"text": "Sorry, I didn't catch that."},
  "voice": {
    "languageCode": "en-US",
    "name": "en-US-Neural2-F"  # Giọng nữ Neural2
  },
  "audioConfig": {
    "audioEncoding": "MP3",
    "speakingRate": 0.9,        # Chậm 10%
    "pitch": 0,
    "volumeGainDb": 0
  }
}

r = requests.post(f"{url}?key={API_KEY}", json=payload)
audio_b64 = r.json()['audioContent']
audio_bytes = base64.b64decode(audio_b64)

with open(f'/tmp/english_audio/{sentence_id}.mp3', 'wb') as f:
    f.write(audio_bytes)
```

**Output:** `/tmp/english_audio/*.mp3` — 19 files, tên file = `sentenceId`

---

### 2. Copy vào BE wwwroot

```bash
mkdir -p ThuyVanEnglishAppBE/EnglishApp.HttpApi.Host/wwwroot/audio
cp /tmp/english_audio/*.mp3 ThuyVanEnglishAppBE/EnglishApp.HttpApi.Host/wwwroot/audio/
```

**Gitignore:**
```
# .gitignore
wwwroot/audio/
```

**Kết quả:** 19 file MP3 trong `wwwroot/audio/{sentenceId}.mp3`

---

### 3. Enable Static Files trên BE

**File:** `EnglishAppHttpApiHostModule.cs`

```csharp
public override void OnApplicationInitialization(ApplicationInitializationContext context)
{
    var app = context.GetApplicationBuilder();
    // ...
    app.UseCorrelationId();
    app.UseStaticFiles();  // ← Thêm dòng này
    app.MapAbpStaticAssets();
    app.UseRouting();
    // ...
}
```

**Test:**
```bash
curl -I https://localhost:44396/audio/c516dde4-7a38-4149-94b2-a9a245a0af25.mp3
# → 200 audio/mpeg
```

---

### 4. Insert DB — SentenceMedias

**Table:** `SentenceMedias`

```sql
INSERT INTO "SentenceMedias" (
  "Id", "SentenceId", "MediaType", "MediaUrl",
  "MimeType", "IsApproved", "DisplayOrder", "CreatedAt"
) VALUES (
  gen_random_uuid(),
  'c516dde4-7a38-4149-94b2-a9a245a0af25',
  'audio',
  'https://localhost:44396/audio/c516dde4-7a38-4149-94b2-a9a245a0af25.mp3',
  'audio/mpeg',
  true,
  1,
  NOW()
);
```

**Script tự động:** `/tmp/gen_sql.py` gen 19 INSERT statements

---

### 5. BE API trả audioUrl

**SentenceDto.cs:**
```csharp
public class SentenceDto
{
    public Guid Id { get; set; }
    public string EnglishText { get; set; }
    public string VietnameseseText { get; set; }
    public List<SentenceMediaDto> Medias { get; set; } = new();

    // Computed properties
    public string AudioUrl => Medias?.Find(m => m.MediaType == "audio")?.MediaUrl ?? string.Empty;
    public string ImageUrl => Medias?.Find(m => m.MediaType == "image")?.MediaUrl ?? string.Empty;
}
```

**SentenceService.cs — GetList():**
```csharp
var dtos = ObjectMapper.Map<List<Sentence>, List<SentenceDto>>(items);

// Load medias cho tất cả sentences
if (items.Any())
{
    var sentenceIds = items.Select(x => x.Id).ToList();
    var mediaQuery = await _mediaRepository.GetQueryableAsync();
    var allMedias = mediaQuery
        .Where(x => sentenceIds.Contains(x.SentenceId) && x.IsApproved)
        .OrderBy(x => x.DisplayOrder)
        .ToList();

    foreach (var dto in dtos)
    {
        var sentenceMedias = allMedias.Where(m => m.SentenceId == dto.Id).ToList();
        dto.Medias = ObjectMapper.Map<List<SentenceMedia>, List<SentenceMediaDto>>(sentenceMedias);
    }
}
```

**API Response:**
```json
{
  "items": [
    {
      "id": "c516dde4-7a38-4149-94b2-a9a245a0af25",
      "englishText": "Sorry, I didn't catch that.",
      "vietnameseseText": "Xin lỗi, tôi không nghe rõ.",
      "audioUrl": "https://localhost:44396/audio/c516dde4-7a38-4149-94b2-a9a245a0af25.mp3",
      "imageUrl": ""
    }
  ]
}
```

---

### 6. FE AudioService play

**File:** `lib/core/services/audio_service.dart`

```dart
import 'package:web/web.dart' as web;

class AudioService {
  web.HTMLAudioElement? _audioEl;

  Future<void> playAudioUrl(String url) async {
    if (url.isEmpty) return;
    try {
      await stopAudio();

      final el = web.HTMLAudioElement();
      el.src = url;
      el.preload = 'auto';
      el.crossOrigin = 'anonymous';
      _audioEl = el;

      el.play();  // ← Không redirect, không CORS issue
      debugPrint('🎵 Playing: $url');
    } catch (e) {
      debugPrint('❌ playAudioUrl error: $e');
    }
  }

  Future<void> stopAudio() async {
    _audioEl?.pause();
    _audioEl = null;
  }

  // Fallback: Web Speech API
  Future<void> speak(String text, {String language = 'en-US', double? speed}) async {
    final synth = web.window.speechSynthesis;
    synth.cancel();
    final utterance = web.SpeechSynthesisUtterance(text);
    utterance.lang = language;
    utterance.rate = speed ?? 0.85;
    synth.speak(utterance);
  }
}
```

**Usage trong sentence_study_screen.dart:**
```dart
Future<void> _playAudio(String audioUrl, String text) async {
  if (audioUrl.isNotEmpty) {
    await _audioService.playAudioUrl(audioUrl);  // Neural2-F MP3
  } else {
    await _audioService.speak(text);              // Fallback TTS
  }
}
```

---

## So sánh: Google Drive vs BE Static

| | Google Drive | BE Static (✅ Đang dùng) |
|---|---|---|
| **URL format** | `drive.google.com/uc?id=...` | `localhost:44396/audio/{id}.mp3` |
| **Redirect** | 2 lần (303 → 200) | Không |
| **CORS** | Phức tạp | Không cần config |
| **Latency** | ~500ms (lần đầu) | ~10ms (local) |
| **Chrome autoplay** | Blocked đôi khi | OK luôn |
| **Dependency** | Service Account, rclone OAuth | Không (self-host) |
| **Storage** | Drive quota 15GB | wwwroot ~400KB (19 files) |

**Kết luận:** BE Static tốt hơn cho <100 files. Nếu scale lên 1000+ câu → xem xét CDN (Cloudflare R2, AWS S3).

---

## Troubleshooting

### "Nghe như tiếng từ cõi âm"
- **Nguyên nhân:** Drive redirect + Chrome buffer MP3 chậm
- **Fix:** Đổi sang BE static → OK

### "Lần 2 không nghe thấy"
- **Nguyên nhân:** `_audioEl` không reset
- **Fix:** Tạo `HTMLAudioElement` mới mỗi lần play

### "Auto-play lần đầu"
- **Nguyên nhân:** 2 chỗ trong `sentence_study_screen.dart` gọi `_playAudio()` tự động
- **Fix:** Xóa line 111-118 và 196-203

---

## Future Work

- [ ] Batch upload MP3 endpoint (admin upload nhiều file)
- [ ] TTS on-demand (gen audio cho câu mới ngay lập tức)
- [ ] CDN cho production (nếu >1000 câu)
- [ ] Offline cache audio (Service Worker)

---

**Last updated:** 2026-06-14 04:52 UTC
