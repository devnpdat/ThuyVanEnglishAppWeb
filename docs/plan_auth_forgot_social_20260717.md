# Plan: Quên mật khẩu + Đăng nhập Social (Google / Facebook)
**Date**: 2026-07-17
**Project**: ThuyVanEnglishApp (cá nhân)
**Status**: DRAFT

---

## 1. Yêu cầu (Requirements)

### Mô tả
Bổ sung 2 luồng auth còn thiếu:
1. **Quên mật khẩu** — user nhập email → nhận link reset qua mail → đặt lại mật khẩu mới
2. **Social Login** — đăng nhập bằng Google hoặc Facebook, không cần nhớ password

### Acceptance Criteria

#### Quên mật khẩu
- [ ] AC1: Màn hình login có link "Quên mật khẩu?"
- [ ] AC2: Nhập email → BE gửi email reset (ABP built-in forgot-password)
- [ ] AC3: User click link trong mail → mở màn hình đặt mật khẩu mới
- [ ] AC4: Đặt mật khẩu mới thành công → tự redirect về login
- [ ] AC5: Email không tồn tại → hiện lỗi top-right Overlay

#### Social Login
- [ ] AC6: Màn hình login có nút "Đăng nhập với Google" + "Đăng nhập với Facebook"
- [ ] AC7: Click Google/Facebook → OAuth2 popup → user authorize → FE nhận token → login vào app
- [ ] AC8: Lần đầu social login → BE tự tạo tài khoản ABP liên kết với email social
- [ ] AC9: Các lần sau → login trực tiếp, không hỏi lại
- [ ] AC10: Social login thành công → cùng flow như login thường (lưu token, vào home)

### Out of scope
- Reset password qua SMS
- Apple Sign In (tốn phí dev account)
- Link/unlink social account sau khi đăng nhập

---

## 2. Phân tích kỹ thuật

### 2a. Quên mật khẩu — phân tích

ABP Framework đã có sẵn endpoint forgot-password:
- `POST /api/account/send-password-reset-code` — gửi email reset
- `POST /api/account/reset-password` — đặt mật khẩu mới bằng token

**Flow:**
```
User nhập email
  → FE POST /api/account/send-password-reset-code {email}
  → BE gửi mail (ABP EmailSender) với link chứa ?userId=...&resetToken=...
  → User click link → browser mở app tại /reset-password?userId=X&token=Y
  → FE đọc query params → hiện form nhập mật khẩu mới
  → FE POST /api/account/reset-password {userId, resetToken, password}
  → BE xác thực → đổi mật khẩu → FE redirect /login
```

**Lưu ý ABP:**
- Link reset trong email mặc định trỏ về `App.RedirectAllowedUrls` (appsettings)
- Cần cấu hình `RedirectAllowedUrls` thêm FE URL local + prod
- Reset token từ ABP là base64url, cần decode trước khi gửi

### 2b. Social Login — phân tích

**Hướng đơn giản nhất với ABP + Flutter Web:**

ABP hỗ trợ External Login qua OpenIddict. Flow:
```
User click "Login với Google"
  → FE mở popup: GET /api/account/external-login?provider=Google&returnUrl=...
  → ABP redirect sang Google OAuth consent
  → Google callback về BE /signin-google
  → BE tạo/link ABP user → redirect về FE với token
  → FE parse token từ URL → lưu → vào home
```

**Thách thức:**
- ABP ExternalLogin cần cấu hình Google/Facebook credentials trong BE (appsettings)
- Flutter Web không dùng native SDK được → dùng `google_sign_in` web package hoặc popup OAuth
- Facebook trên web cần Facebook JS SDK hoặc OAuth redirect

**Hướng triển khai thực tế cho Flutter Web:**

Option A — ABP External Login (backend-driven):
- BE xử lý OAuth redirect, FE chỉ mở URL + đọc token từ redirect
- Phức tạp: cần cấu hình Google Cloud Console + Facebook App + ABP module

Option B — Flutter `google_sign_in` (frontend-driven):
- FE lấy Google `idToken` → gửi lên BE custom endpoint → BE verify + tạo ABP user → trả token
- Đơn giản hơn cho Flutter Web, kiểm soát được flow

**Khuyến nghị: Option B cho Google trước, Facebook sau**

### 2c. Impact Analysis

| Layer | File | Loại thay đổi |
|---|---|---|
| FE Screen | `login_screen.dart` | Modify — thêm link forgot + nút social |
| FE Screen | `forgot_password_screen.dart` | New |
| FE Screen | `reset_password_screen.dart` | New |
| FE BLoC Event | `auth_event.dart` | Modify — thêm 4 events |
| FE BLoC State | `auth_state.dart` | Modify — thêm states |
| FE BLoC | `auth_bloc.dart` | Modify — thêm handlers |
| FE Repository | `auth_repository.dart` | Modify — thêm 3 methods |
| FE Config | `app_config.dart` | Modify — thêm endpoints |
| FE Router | `app.dart` | Modify — thêm routes |
| FE pubspec | `pubspec.yaml` | Modify — thêm `google_sign_in` |
| BE Config | `appsettings.json` | Modify — Google credentials + RedirectUrls |
| BE Controller | `AccountExtensionController.cs` | Modify — thêm `/google-login` endpoint |
| BE Module | `EnglishAppHttpApiHostModule.cs` | Modify — cấu hình Google OAuth |

### 2d. Risk

- **Google Cloud Console setup**: cần tạo OAuth 2.0 credentials (Client ID + Secret) — nếu chưa có thì mất thêm 15 phút setup bên ngoài code
- **ABP Email SMTP**: nếu chưa config EmailSender (SmtpHost, port, từ) thì forgot-password gửi mail sẽ fail silently
- **Flutter Web CORS + popup**: Google Sign-In trên web cần domain được whitelist trong Google Console
- **Facebook**: cần Facebook App approval nếu muốn dùng public — có thể để phase 2

---

## 3. Breakdown Tasks

### Phase 1 — Quên mật khẩu (ưu tiên, đơn giản hơn)

#### BE
| # | Task | File | Est |
|---|---|---|---|
| BE1 | Verify ABP đã có endpoint send-password-reset-code chưa (swagger check) | AccountExtensionController.cs | 10m |
| BE2 | Cấu hình SMTP EmailSender trong appsettings.Development.json | appsettings.Development.json | 15m |
| BE3 | Thêm FE URL vào RedirectAllowedUrls (local + Railway) | appsettings.json | 5m |

#### FE
| # | Task | File | Est |
|---|---|---|---|
| FE1 | Thêm endpoints `forgotPasswordEndpoint` + `resetPasswordEndpoint` vào AppConfig | app_config.dart / app_config.dev.dart / app_config.prod.dart | 10m |
| FE2 | Thêm events: `AuthForgotPasswordEvent`, `AuthResetPasswordEvent` | auth_event.dart | 5m |
| FE3 | Thêm states: `passwordResetSent`, `passwordResetSuccess` | auth_state.dart | 5m |
| FE4 | Thêm methods `sendPasswordResetCode()` + `resetPassword()` vào AuthRepository | auth_repository.dart | 20m |
| FE5 | Handler `_onForgotPassword` + `_onResetPassword` trong AuthBloc | auth_bloc.dart | 20m |
| FE6 | Màn hình ForgotPasswordScreen (nhập email + gửi) | forgot_password_screen.dart | 30m |
| FE7 | Màn hình ResetPasswordScreen (nhập mật khẩu mới, đọc token từ URL) | reset_password_screen.dart | 30m |
| FE8 | Thêm link "Quên mật khẩu?" vào LoginScreen | login_screen.dart | 10m |
| FE9 | Thêm routes `/forgot-password` + `/reset-password` vào Router | app.dart | 10m |
| FE10 | Chạy build_runner để gen freezed code | terminal | 5m |
| FE11 | Test local + unit test ForgotPasswordBloc | test/auth/ | 30m |

**Tổng Phase 1: ~3h**

---

### Phase 2 — Social Login Google

#### Setup (ngoài code)
| # | Task | Detail | Est |
|---|---|---|---|
| S1 | Tạo Google Cloud Project + OAuth 2.0 Client ID | console.cloud.google.com | 20m |
| S2 | Whitelist origins: localhost:5173 + thuyvan.up.railway.app | Google Console | 5m |

#### FE
| # | Task | File | Est |
|---|---|---|---|
| FE12 | Thêm `google_sign_in: ^6.2.1` vào pubspec.yaml | pubspec.yaml | 5m |
| FE13 | Config web/index.html — thêm Google Sign-In script tag + client_id meta | web/index.html | 10m |
| FE14 | Thêm event `AuthSocialLoginEvent(provider, idToken)` | auth_event.dart | 5m |
| FE15 | Thêm method `socialLogin(provider, idToken)` vào AuthRepository | auth_repository.dart | 20m |
| FE16 | Handler `_onSocialLogin` trong AuthBloc — gọi GoogleSignIn.signIn() → lấy idToken → gọi BE | auth_bloc.dart | 30m |
| FE17 | Thêm nút Google vào LoginScreen (GestureDetector + Google logo) | login_screen.dart | 20m |

#### BE
| # | Task | File | Est |
|---|---|---|---|
| BE4 | Thêm endpoint `POST /api/account/google-login` — nhận idToken → verify via Google API → tạo/tìm ABP user → trả JWT | AccountExtensionController.cs | 45m |
| BE5 | Thêm `Google.Apis.Auth` NuGet package | .csproj | 5m |
| BE6 | Config Google ClientId trong appsettings | appsettings.json | 5m |

**Tổng Phase 2: ~2.5h**

---

### Phase 3 — Social Login Facebook (sau Phase 2 stable)
- Tương tự Google nhưng dùng Facebook Graph API để verify token
- Cần Facebook App ID + Secret
- Để phase riêng, implement sau

---

## 4. Git Strategy

Branch: `feature/auth-forgot-social` từ `main`
Merge vào main sau khi anh approve + test local OK

---

## 5. Test Plan

### Quên mật khẩu
| TC | Scenario | Input | Expected |
|---|---|---|---|
| TC1 | Email tồn tại | email hợp lệ đang có account | Toast "Đã gửi mail reset" + link nhận trong hòm thư |
| TC2 | Email không tồn tại | email@khongco.com | Lỗi top-right "Email không tồn tại" |
| TC3 | Email rỗng | (bỏ trống) | Validation error inline |
| TC4 | Click link reset hợp lệ | URL có đúng userId + token | Hiện form nhập mật khẩu mới |
| TC5 | Token hết hạn (>24h) | token cũ | Lỗi "Link đã hết hạn, vui lòng yêu cầu lại" |
| TC6 | Mật khẩu mới không hợp lệ | < 6 ký tự | Validation error inline |
| TC7 | Reset thành công | mật khẩu mới hợp lệ | Redirect về /login + toast thành công |

### Social Login Google
| TC | Scenario | Input | Expected |
|---|---|---|---|
| TC8 | Lần đầu login Google | account Google mới | Tạo account ABP mới + login vào app |
| TC9 | Login Google đã có account | Google account đã từng dùng | Login thẳng vào app |
| TC10 | User cancel popup Google | Đóng popup | Không có lỗi, ở lại màn hình login |
| TC11 | Token Google invalid | idToken giả | Lỗi top-right "Xác thực Google thất bại" |

---

## Review Checklist
- [ ] Error handling dùng Overlay top-right (KHÔNG SnackBar)
- [ ] Không hardcode client_id, client_secret trong FE code — đọc từ env/config
- [ ] Reset password token được encode/decode đúng (base64url)
- [ ] Social login không block main thread (async/await đúng)
- [ ] flutter test pass
- [ ] flutter build web pass
