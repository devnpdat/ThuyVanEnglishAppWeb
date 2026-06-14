// Chỉ export getIt instance — KHÔNG import audio_service.dart
// Dùng file này trong test để tránh kéo dart:js_interop vào Dart VM
import 'package:get_it/get_it.dart';

export 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;
