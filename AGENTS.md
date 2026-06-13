# AGENTS.md — ThuyVanEnglishAppWeb

Frontend cho ứng dụng học tiếng Anh theo câu. Flutter 3.44.1 Web.

---

## URLs & Repos

| Item | Giá trị |
|------|---------|
| Production | https://thuyvan.up.railway.app |
| GitHub | https://github.com/devnpdat/ThuyVanEnglishAppWeb |
| Branch chính | main |
| Deploy | Railway (auto-deploy khi push main) |
| Backend API | https://vanvy.up.railway.app |

---

## Cấu trúc project

```
ThuyVanEnglishAppWeb/
├── Dockerfile                              ← Multi-stage: flutter build → nginx serve
├── nginx.conf.template                     ← Static web server
├── start.sh                                ← Replace $PORT cho Railway
├── web/                                    ← Flutter web platform files
│   ├── index.html
│   ├── manifest.json
│   └── favicon.png
├── pubspec.yaml                            ← Dependencies (dio, flutter_bloc, freezed, injectable)
└── lib/
    ├── main.dart                           ← Entry point
    ├── app.dart                            ← MaterialApp + Router + BlocProviders
    ├── core/
    │   ├── config/
    │   │   └── app_config.dart             ← API URLs, timeouts, feature flags
    │   ├── services/
    │   │   ├── http_client.dart            ← Dio + interceptors, Bearer token
    │   │   ├── audio_service.dart          ← Audio playback (just_audio)
    │   │   ├── local_storage_service.dart  ← SharedPreferences wrapper
    │   │   └── sync_manager.dart           ← Offline sync (TODO)
    │   └── di/
    │       ├── service_locator.dart        ← GetIt DI container
    │       └── injection.dart              ← @injectable setup
    └── features/
        ├── auth/
        │   ├── data/repositories/
        │   │   └── auth_repository.dart    ← Login (2-step), Register, GetProfile
        │   └── presentation/
        │       ├── bloc/
        │       │   ├── auth_bloc.dart
        │       │   ├── auth_event.dart
        │       │   └── auth_state.dart
        │       └── screens/
        │           └── login_screen.dart   ← Email + Password, toggle Register, error toast top-right
        ├── home/
        │   ├── data/
        │   │   ├── dtos/dashboard_dto.dart
        │   │   └── repositories/dashboard_repository.dart
        │   └── presentation/
        │       ├── bloc/dashboard_bloc.dart
        │       └── screens/home_screen.dart
        ├── learning/
        │   ├── data/
        │   │   ├── dtos/
        │   │   │   ├── topic_dto.dart
        │   │   │   ├── sentence_dto.dart
        │   │   │   ├── learning_plan_dto.dart
        │   │   │   └── daily_learning_dto.dart
        │   │   └── repositories/
        │   │       ├── topic_repository.dart
        │   │       ├── sentence_repository.dart
        │   │       ├── learning_plan_repository.dart
        │   │       ├── daily_learning_repository.dart
        │   │       └── learning_repository.dart
        │   └── presentation/
        │       ├── bloc/
        │       │   ├── topic_list_bloc.dart
        │       │   ├── sentence_list_bloc.dart
        │       │   ├── learning_plan_bloc.dart
        │       │   └── daily_learning_bloc.dart
        │       └── screens/
        │           ├── topic_list_screen.dart
        │           ├── sentence_list_screen.dart
        │           ├── sentence_study_screen.dart
        │           ├── learning_plans_screen.dart
        │           ├── learning_plan_detail_screen.dart
        │           └── daily_learning_screen.dart
        ├── quiz/
        │   ├── data/repositories/quiz_repository.dart
        │   └── presentation/
        │       ├── bloc/quiz_bloc.dart
        │       └── screens/
        │           ├── quiz_screen.dart
        │           └── quiz_stats_screen.dart
        ├── review/
        │   ├── data/
        │   │   ├── dtos/review_dto.dart
        │   │   └── repositories/review_repository.dart
        │   └── presentation/
        │       ├── bloc/review_bloc.dart
        │       └── screens/
        │           ├── review_screen.dart
        │           └── mastered_sentences_screen.dart
        ├── rewards/
        │   ├── data/repositories/rewards_repository.dart
        │   └── presentation/
        │       ├── bloc/rewards_bloc.dart
        │       └── screens/rewards_screen.dart
        ├── profile/
        │   ├── data/repositories/user_profile_repository.dart
        │   └── presentation/
        │       ├── bloc/profile_bloc.dart
        │       └── screens/profile_screen.dart
        └── ai/
            └── data/repositories/ai_repository.dart
```

---

## Auth Flow (Frontend)

Login state machine:
```
Initial → Loading → (Authenticated | Error)
```

Login logic (auth_repository.dart):
```dart
1. POST /api/account/login
   Body: { userNameOrEmailAddress, password, rememberMe }
   → {result:1} = OK

2. POST /connect/token
   Form: grant_type=password, username, password,
         client_id=EnglishApp_App, client_secret=1q2w3e*,
         scope=EnglishApp offline_access
   → {access_token, expires_in}

3. GET /api/account/my-profile
   Bearer: <access_token>
   → {id, userName, emailAddress, name, surname}

4. Save to SharedPreferences:
   - auth_token
   - user_id
   - user_email
   - user_display_name
```

Router tự động redirect:
- Authenticated → `/home`
- Unauthenticated → `/login`

---

## API Configuration

File: `lib/core/config/app_config.dart`

```dart
static const String apiBaseUrl = 'https://vanvy.up.railway.app';

// Feature endpoints
static const String topicsEndpoint = '$apiBaseUrl/api/v1/topics';
static const String sentencesEndpoint = '$apiBaseUrl/api/v1/sentences';
static const String quizEndpoint = '$apiBaseUrl/api/v1/quiz';
static const String reviewEndpoint = '$apiBaseUrl/api/v1/review';
static const String learningPlanEndpoint = '$apiBaseUrl/api/v1/learningplan';
static const String dashboardEndpoint = '$apiBaseUrl/api/v1/dashboard';
static const String aiEndpoint = '$apiBaseUrl/api/v1/ai';

// Auth endpoints
static const String authLoginEndpoint = '$apiBaseUrl/api/account/login';
static const String authRegisterEndpoint = '$apiBaseUrl/api/account/register';
```

Khi đổi BE domain: chỉ sửa `apiBaseUrl`, các endpoint tự update.

---

## Dockerfile key points

```dockerfile
# Stage 1: Build Flutter Web
FROM debian:bullseye-slim AS build
ENV FLUTTER_VERSION=3.44.1
RUN curl -fsSL "https://storage.googleapis.com/.../flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" | tar xJ -C /opt
RUN git config --global --add safe.directory /opt/flutter  # Fix dubious ownership
RUN /opt/flutter/bin/flutter precache --web
COPY . /app
WORKDIR /app
RUN /opt/flutter/bin/flutter pub get
RUN /opt/flutter/bin/flutter build web --release

# Stage 2: Serve với nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY start.sh /start.sh
CMD ["/start.sh"]
```

Lưu ý:
- `git config --global --add safe.directory /opt/flutter` — bắt buộc vì Git >= 2.35.2 chặn dubious ownership
- `pubspec.yaml` phải có trong repo (Flutter cần để resolve dependencies)
- `web/` folder phải có (để `flutter build web` chạy được)

---

## Đã làm (Done)

- [x] Flutter project scaffold (BLoC + Clean Architecture)
- [x] DI setup (GetIt + injectable)
- [x] HttpClient với Dio + Bearer interceptor
- [x] Auth flow: Login (2-step), Register, auto-token refresh
- [x] 7 features với repository + BLoC + screens:
  - [x] auth (login_screen with top-right error toast)
  - [x] home (dashboard)
  - [x] learning (topics, sentences, study, plans)
  - [x] quiz
  - [x] review
  - [x] rewards
  - [x] profile
- [x] Freezed DTOs (immutable, copyWith, toJson/fromJson)
- [x] Go Router với auth guard
- [x] Deploy Railway thành công tại thuyvan.up.railway.app
- [x] Error toast: Overlay widget top-right, auto-dismiss 4s, nút X

## Đang làm (In Progress)

- [ ] Test login end-to-end
- [ ] Fix CORS nếu BE chặn

## Chưa làm (TODO)

### Critical (P0)
- [ ] Audio playback integration (just_audio + BE audio URLs)
- [ ] Daily learning 5 câu logic
- [ ] Spaced repetition algorithm (review schedule)
- [ ] Offline mode (sync_manager.dart)

### High (P1)
- [ ] Dashboard API integration (home_screen hiện tại chỉ placeholder)
- [ ] Quiz flow end-to-end
- [ ] Review screen với SRS intervals
- [ ] Rewards unlocking logic

### Medium (P2)
- [ ] Custom sentence + image upload
- [ ] AI sentence generation integration
- [ ] Profile edit (change password, avatar)
- [ ] Dark mode

### Low (P3)
- [ ] Animations (lottie rewards, confetti)
- [ ] Sound effects
- [ ] Leaderboard (nếu multi-user)
- [ ] Widget tests (BLoC tests có 2: auth_bloc_test, learning_bloc_test_stub)

---

## Pitfalls đã gặp

1. **OAuth2 vs ABP REST**: Ban đầu nhầm `/connect/token` (dùng thẳng) với `/api/account/login` (ABP endpoint thật). Phải gọi 2 bước: login → token.

2. **Empty token error**: BE trả `{result:1}` không có `accessToken` field → phải parse `result` trước, rồi gọi `/connect/token` riêng.

3. **SnackBar góc dưới khó thấy**: Flutter SnackBar mặc định bottom-left. Đổi sang `Overlay` widget + `Positioned(top:24)` để hiện top-right.

4. **Dockerfile lỗi dubious ownership**: Flutter SDK trong Docker có ownership khác user → Git từ chối. Fix: `git config --global --add safe.directory /opt/flutter`.

5. **pubspec.yaml thiếu**: Ban đầu không push `pubspec.yaml` → Railway build fail. File này bắt buộc cho Flutter.

6. **web/ folder thiếu**: Flutter cần `web/index.html` + `manifest.json` để build web. Phải có trong repo.

7. **API config hardcode**: Trước đổi domain BE phải find-replace toàn bộ code. Giờ tập trung vào `app_config.dart` → chỉ sửa 1 chỗ.

---

## Testing Strategy

### Unit Tests (TODO)
- BLoC tests: `auth_bloc_test.dart`, `learning_bloc_test.dart`
- Repository tests với mock Dio

### Widget Tests (TODO)
- `login_screen_test.dart`: verify form validation, button states
- `home_screen_test.dart`: verify dashboard tiles render

### Integration Tests (TODO)
- `test_driver/app_test.dart`: E2E login → home → daily learning

---

## Dependencies chính

```yaml
dependencies:
  flutter_bloc: ^8.1.3        # State management
  freezed_annotation: ^2.4.1  # Immutable models
  injectable: ^2.3.2          # DI
  get_it: ^7.6.4              # Service locator
  dio: ^5.4.0                 # HTTP client
  shared_preferences: ^2.2.2  # Local storage
  go_router: ^13.0.0          # Navigation
  just_audio: ^0.9.36         # Audio playback

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  injectable_generator: ^2.4.1
  json_serializable: ^6.7.1
  flutter_test:
  mockito: ^5.4.4             # Mock testing
```

---

## Environment (Railway)

Railway tự detect Dockerfile và build. Không cần env vars đặc biệt (API URL hardcode trong app_config.dart).

Nếu cần dynamic config sau này: dùng `--dart-define` trong build command hoặc Firebase Remote Config.

---

## Next Steps (for new session)

1. **Test login**: Vào https://thuyvan.up.railway.app, thử đăng nhập với user seed data từ BE
2. **Implement dashboard**: Call `/api/v1/dashboard`, render 5 tiles (streak, sentences mastered, review due, quiz score, rewards)
3. **Daily learning flow**: 5 câu mỗi ngày, audio loop, gõ lại, correct/incorrect feedback
4. **Audio service**: Integrate `just_audio` với BE `/api/v1/sentences/{id}/audio`
5. **Offline mode**: `sync_manager.dart` — cache sentences locally, sync when online
