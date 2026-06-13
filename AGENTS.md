# AGENTS.md — ThuyVanEnglishAppWeb

Frontend cho ứng dụng học tiếng Anh theo câu. Flutter 3.44.1 Web.

---

## Quick Links

- **Production**: https://thuyvan.up.railway.app
- **GitHub**: https://github.com/devnpdat/ThuyVanEnglishAppWeb
- **Backend API**: https://vanvy.up.railway.app
- **Local**: http://localhost:5173

📖 **Chi tiết**: Xem [docs/README.md](docs/README.md) để biết cấu trúc, API flow, dependencies

---

## Quick Start (Local)

```bash
flutter run -d chrome --web-port=5173
# → http://localhost:5173
```

**Login test**:
- Username: `devdatnp`
- Password: `M1nhkh@nh1`

---

## Đã làm (Done) ✅

### Core Setup
- [x] Flutter Web project (BLoC + Clean Architecture)
- [x] DI (GetIt + injectable)
- [x] HttpClient (Dio + Bearer interceptor)
- [x] Go Router + auth guard
- [x] Deploy Railway

### Auth & Features
- [x] Login 2-step (ABP `/api/account/login` → `/connect/token`)
- [x] 7 features hoàn chỉnh: auth, home, learning, quiz, review, rewards, profile
- [x] Error toast top-right (Overlay widget, 4s auto-dismiss, nút X)
- [x] Freezed DTOs immutable

### Audio & Learning
- [x] **AudioService** hybrid:
  - ✅ `HTMLAudioElement` play MP3 từ BE (`https://localhost:44396/audio/{id}.mp3`)
  - ✅ Fallback Web Speech API khi `audioUrl` rỗng
- [x] **sentence_study_screen** — 4 bước: Nghe → Đọc → Gõ → Quiz
- [x] **Tắt autoplay** — user bấm nút loa mới phát
- [x] Audio từ BE Neural2-F (19 câu) — chất lượng cao, không lag

### UI/UX
- [x] Login screen với toggle Register
- [x] Admin icon trên AppBar (vào `/admin` — sentence list)
- [x] Responsive layout

---

## Đang làm (In Progress) 🚧

- [ ] Commit FE lên GitHub (AGENTS.md đã update)
- [ ] Cập nhật Railway auto-deploy

---

## Chưa làm (TODO) 📋

### P0 — Critical
- [ ] Daily learning 5 câu logic (chọn random chưa học)
- [ ] Spaced repetition (review schedule)
- [ ] Dashboard API integration (home_screen placeholder)

### P1 — High
- [ ] Quiz flow end-to-end (multiple choice)
- [ ] Review screen với SRS intervals
- [ ] Rewards unlocking logic

### P2 — Medium
- [ ] Admin CRUD sentences/media (image + audio upload)
- [ ] Gemini gen ảnh minh họa cho câu mới
- [ ] Profile edit (password, avatar)
- [ ] Dark mode

### P3 — Low
- [ ] Animations (Lottie rewards, confetti)
- [ ] Sound effects
- [ ] Widget tests

---

## Pitfalls đã gặp 🐛

1. **OAuth2 2-bước**: `/api/account/login` trả `{result:1}` → gọi tiếp `/connect/token` để lấy Bearer token
2. **SnackBar góc dưới**: đổi sang `Overlay` widget + `Positioned(top:24)` cho top-right
3. **Dockerfile dubious ownership**: `git config --global --add safe.directory /opt/flutter`
4. **API hardcode**: tập trung vào `app_config.dart` thay vì scatter khắp code
5. **Auto-play audio**: user không thích → tắt 2 chỗ trong `sentence_study_screen.dart` (line 111, 196)
6. **Drive URL redirect**: Chrome block audio → chuyển sang serve từ BE static files

---

## Tài liệu bổ sung

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — Clean Architecture layers, DI, BLoC pattern
- [docs/API.md](docs/API.md) — Full API endpoints, auth flow, response samples
- [docs/AUDIO.md](docs/AUDIO.md) — Audio pipeline: TTS Neural2 → BE static → FE play
- [docs/DEPLOY.md](docs/DEPLOY.md) — Railway deploy, Dockerfile, nginx config

---

**Last updated**: 2026-06-14 04:48 UTC  
**Status**: Audio hoàn chỉnh, login OK, sẵn sàng commit + deploy
