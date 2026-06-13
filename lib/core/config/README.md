# Environment Configuration — Frontend

FE có 2 config files theo env:

```
lib/core/config/
├── app_config.dart       ← Selector (tự động chọn dev/prod)
├── app_config.dev.dart   ← Local (localhost:44396)
└── app_config.prod.dart  ← Production (vanvy.up.railway.app)
```

---

## Cách hoạt động

**app_config.dart** tự động chọn:
```dart
kReleaseMode ? prod.AppConfig : dev.AppConfig
```

- `flutter run` → Development (localhost:44396)
- `flutter build web --release` → Production (vanvy.up.railway.app)

**Không cần config gì thêm** — Flutter tự detect.

---

## Local Development

```bash
flutter run -d chrome --web-port=5173
# → Dùng app_config.dev.dart
# → Backend: https://localhost:44396
# → allowSelfSignedCerts: true
# → enableDebugLogging: true
```

---

## Production Build (Railway)

```bash
flutter build web --release
# → Dùng app_config.prod.dart
# → Backend: https://vanvy.up.railway.app
# → allowSelfSignedCerts: false
# → enableDebugLogging: false
```

Railway Dockerfile đã có `--release` flag → tự động dùng prod config.

---

## So sánh Dev vs Prod

| Config | Development | Production |
|--------|-------------|------------|
| **apiBaseUrl** | https://localhost:44396 | https://vanvy.up.railway.app |
| **allowSelfSignedCerts** | true | false |
| **enableDebugLogging** | true | false |
| **enableOfflineMode** | true | false |

---

## Thêm config mới

1. Thêm vào `app_config.dev.dart`
2. Thêm vào `app_config.prod.dart`
3. Thêm getter vào `app_config.dart`

Ví dụ:
```dart
// app_config.dev.dart
static const String newSetting = 'dev_value';

// app_config.prod.dart
static const String newSetting = 'prod_value';

// app_config.dart
static String get newSetting => _config.newSetting;
```

---

## Debug

In ra env hiện tại:
```dart
debugPrint('Current env: ${AppConfig.currentEnv}');
debugPrint('API URL: ${AppConfig.apiBaseUrl}');
```

---

**Last updated:** 2026-06-14 05:06 UTC
