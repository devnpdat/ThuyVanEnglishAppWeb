# Frontend Integration Tests

Test suite cho ThuyVanEnglishAppWeb — verify API contract với BE.

---

## Quick Start

**Requirements:**
- BE đang chạy: `https://localhost:44396`
- Bash + curl + python3

**Chạy test:**
```bash
cd /Users/npdat132/Works/FRT/ThuyVanEnglishAppWeb
bash test/integration/test_api_contract.sh
```

**Expected output:**
```
========================================
✅ ALL API CONTRACTS PASSED
========================================
```

---

## Test Coverage

### `test_api_contract.sh` — API Contract Verification

Verify 4 API endpoints chính mà FE phụ thuộc:

1. **POST /api/account/login** — ABP login step 1
2. **POST /connect/token** — OAuth2 Bearer token
3. **GET /api/v1/sentences** — Lấy danh sách câu (admin page)
4. **GET /api/v1/learning/today** — Daily learning session (home screen)

**Không test UI** — chỉ verify contract với BE. Flutter widget test riêng trong `test/` folder.

---

## Khi nào chạy test?

**Trước khi:**
- Commit FE lên GitHub
- Deploy lên Railway
- Update API client (Dio interceptors, DTOs)
- Thay đổi auth flow trong FE

**Sau khi:**
- BE thay đổi API response format
- Update base URL (local ↔ prod)
- Fix CORS issues

---

## TODO — Test mở rộng

### Widget Tests (Flutter)
```bash
flutter test test/features/auth/login_test.dart
flutter test test/features/learning/sentence_study_test.dart
```

- [ ] `login_bloc_test.dart` — Login state management
- [ ] `audio_service_test.dart` — HTMLAudioElement + Web Speech fallback
- [ ] `sentence_study_bloc_test.dart` — 4-step flow (Nghe → Đọc → Gõ → Quiz)
- [ ] `error_overlay_test.dart` — Top-right error toast

### E2E Tests (Optional — cần Selenium)
- [ ] Full login → learn → complete flow trong browser
- [ ] Audio playback (cần real browser với audio support)

---

**Last updated:** 2026-06-14  
**Maintainer:** devdatnp
