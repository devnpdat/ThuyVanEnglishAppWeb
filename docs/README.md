# ThuyVanEnglishApp — Documentation Index

Tài liệu chi tiết cho Frontend (Flutter Web).

---

## Cấu trúc project

```
lib/
├── main.dart                              ← Entry point
├── app.dart                               ← MaterialApp + Router + BlocProviders
├── core/
│   ├── config/app_config.dart            ← API URLs (chỉ sửa 1 chỗ)
│   ├── services/
│   │   ├── http_client.dart              ← Dio + Bearer interceptor
│   │   ├── audio_service.dart            ← HTMLAudioElement + Web Speech API
│   │   ├── local_storage_service.dart    ← SharedPreferences
│   │   └── sync_manager.dart             ← Offline sync (TODO)
│   └── di/
│       ├── service_locator.dart          ← GetIt setup
│       └── injection.dart                ← @injectable
└── features/
    ├── auth/                             ← Login 2-step
    ├── home/                             ← Dashboard
    ├── learning/                         ← Topics, Sentences, Study, Plans, Daily
    ├── quiz/                             ← Quiz + Stats
    ├── review/                           ← Review + Mastered
    ├── rewards/                          ← Rewards screen
    ├── profile/                          ← User profile
    └── ai/                               ← AI repository (Gemini stub)
```

---

## Key Services

### AudioService (`core/services/audio_service.dart`)

**2 modes:**
1. `playAudioUrl(url)` — HTMLAudioElement cho MP3 từ BE
2. `speak(text)` — Web Speech API fallback

**Flow:**
```dart
if (audioUrl.isNotEmpty) {
  audioService.playAudioUrl(audioUrl);  // Neural2-F MP3
} else {
  audioService.speak(text);              // Browser TTS
}
```

**BE URL format:** `https://localhost:44396/audio/{sentenceId}.mp3`

---

### HttpClient (`core/services/http_client.dart`)

Dio wrapper với:
- Bearer token auto-inject từ SharedPreferences
- 401 → logout redirect
- Timeout 30s
- Base URL: `AppConfig.apiBaseUrl`

---

### LocalStorageService

Lưu:
- `auth_token`
- `user_id`
- `user_email`
- `user_display_name`

---

## Features

### Auth (`features/auth/`)

**Login flow:**
1. `POST /api/account/login` → `{result:1}`
2. `POST /connect/token` → `{access_token, expires_in}`
3. `GET /api/account/my-profile` → `{id, userName, ...}`
4. Save token + user info → redirect `/home`

**Login screen:**
- Email/Password input
- Toggle Register
- Error toast top-right (4s auto-dismiss)

---

### Learning (`features/learning/`)

**Screens:**
- `topic_list_screen.dart` — danh sách chủ đề
- `sentence_list_screen.dart` — danh sách câu
- `sentence_study_screen.dart` — học 1 câu (4 bước)
- `daily_learning_screen.dart` — 5 câu/ngày
- `learning_plans_screen.dart` — kế hoạch học
- `learning_plan_detail_screen.dart` — chi tiết plan

**sentence_study_screen — 4 bước:**
1. **Nghe** — bấm loa, nghe audio Neural2-F
2. **Đọc** — đọc câu tiếng Anh
3. **Gõ** — gõ lại câu, kiểm tra đúng/sai
4. **Quiz** — trắc nghiệm nghĩa tiếng Việt

**Auto-play:** đã TẮT (user tự bấm nút loa)

---

### Quiz (`features/quiz/`)

TODO — flow trắc nghiệm multiple choice

---

### Review (`features/review/`)

TODO — spaced repetition schedule

---

### Rewards (`features/rewards/`)

TODO — unlock logic khi đạt milestone

---

### Profile (`features/profile/`)

Hiển thị user info, TODO: edit password/avatar

---

## BLoC Pattern

Mỗi feature có:
- `bloc/` — state management
- `data/repositories/` — API calls
- `data/dtos/` — Freezed models
- `presentation/screens/` — UI

**Example:**
```
learning/
├── data/
│   ├── dtos/sentence_dto.dart
│   └── repositories/sentence_repository.dart
└── presentation/
    ├── bloc/
    │   ├── sentence_list_bloc.dart
    │   ├── sentence_list_event.dart
    │   └── sentence_list_state.dart
    └── screens/
        └── sentence_list_screen.dart
```

---

## Dependencies

```yaml
flutter_bloc: ^8.1.3        # State management
freezed_annotation: ^2.4.1  # Immutable models
injectable: ^2.3.2          # DI
get_it: ^7.6.4              # Service locator
dio: ^5.4.0                 # HTTP
shared_preferences: ^2.2.2  # Local storage
go_router: ^13.0.0          # Navigation
```

**No audio package needed** — dùng `web` package (`dart:js_interop`) để điều khiển `HTMLAudioElement` trực tiếp.

---

## Router (Go Router)

```dart
GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isAuth = getIt<LocalStorageService>().getToken() != null;
    if (!isAuth && state.location != '/login') return '/login';
    if (isAuth && state.location == '/login') return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
    GoRoute(path: '/admin', builder: (_, __) => SentenceListScreen()),
    // ...
  ],
);
```

---

## Testing (TODO)

### Unit Tests
- `auth_bloc_test.dart`
- `learning_bloc_test.dart`
- Repository tests với mock Dio

### Widget Tests
- `login_screen_test.dart`
- `home_screen_test.dart`

### Integration Tests
- E2E: login → home → daily learning

---

## See Also

- [API.md](API.md) — Full API reference
- [AUDIO.md](AUDIO.md) — Audio pipeline chi tiết
- [DEPLOY.md](DEPLOY.md) — Railway deploy
