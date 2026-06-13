import 'package:flutter/material.dart';
import 'package:english_learning_app/app.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

void main() async {
  // MUST be first — required before any plugin/platform channel init
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection AFTER binding is ready
  try {
    configureInjection();
  } catch (e) {
    debugPrint('DI initialization error: $e');
    // Continue anyway - app will show error UI
  }

  runApp(const EnglishLearningApp());
}
