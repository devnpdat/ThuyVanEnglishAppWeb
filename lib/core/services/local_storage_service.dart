import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

// Hive models (adapters auto-registered)
class CachedSentence {
  final String id;
  final String englishText;
  final String vietnameseText;
  final String difficultyLevel;
  final String sentenceType;
  final DateTime cachedAt;

  CachedSentence({
    required this.id,
    required this.englishText,
    required this.vietnameseText,
    required this.difficultyLevel,
    required this.sentenceType,
    required this.cachedAt,
  });

  bool get isExpired =>
      DateTime.now().difference(cachedAt).inHours > 4; // 4 hour TTL
}

class CachedTopic {
  final String id;
  final String name;
  final String slug;
  final String description;
  final DateTime cachedAt;

  CachedTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.cachedAt,
  });

  bool get isExpired => DateTime.now().difference(cachedAt).inHours > 4;
}

class PendingRequest {
  final String id;
  final String endpoint;
  final String method;
  final Map<String, dynamic> body;
  final DateTime createdAt;
  final int retryCount;

  PendingRequest({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.body,
    required this.createdAt,
    this.retryCount = 0,
  });
}

/// Local storage service sử dụng Hive
@singleton
class LocalStorageService {
  late Box<CachedSentence> _sentenceBox;
  late Box<CachedTopic> _topicBox;
  late Box<PendingRequest> _requestBox;
  late Box<dynamic> _settingsBox;

  bool _isInitialized = false;

  /// Initialize Hive và mở các boxes
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    // TODO: Generate adapters with build_runner:
    // flutter pub run build_runner build

    // Open boxes
    _sentenceBox = await Hive.openBox<CachedSentence>('sentences');
    _topicBox = await Hive.openBox<CachedTopic>('topics');
    _requestBox = await Hive.openBox<PendingRequest>('pending_requests');
    _settingsBox = await Hive.openBox('settings');

    _isInitialized = true;
  }

  // ===== SENTENCE CACHE =====

  /// Cache một sentence
  Future<void> cacheSentence(CachedSentence sentence) async {
    await _sentenceBox.put(sentence.id, sentence);
  }

  /// Lấy cached sentence (return null nếu expired)
  Future<CachedSentence?> getSentence(String id) async {
    final cached = _sentenceBox.get(id);
    if (cached != null && !cached.isExpired) {
      return cached;
    }
    // Delete if expired
    await _sentenceBox.delete(id);
    return null;
  }

  /// Cache batch sentences
  Future<void> cacheSentences(List<CachedSentence> sentences) async {
    for (final sentence in sentences) {
      await cacheSentence(sentence);
    }
  }

  /// Get all cached sentences (filter expired)
  List<CachedSentence> getAllSentences() {
    final expired = <String>[];
    final result = <CachedSentence>[];

    for (final entry in _sentenceBox.toMap().entries) {
      if (entry.value.isExpired) {
        expired.add(entry.key);
      } else {
        result.add(entry.value);
      }
    }

    // Clean expired
    for (final key in expired) {
      _sentenceBox.delete(key);
    }

    return result;
  }

  /// Clear all sentence cache
  Future<void> clearSentenceCache() async {
    await _sentenceBox.clear();
  }

  // ===== TOPIC CACHE =====

  /// Cache một topic
  Future<void> cacheTopic(CachedTopic topic) async {
    await _topicBox.put(topic.id, topic);
  }

  /// Get cached topic
  CachedTopic? getTopic(String id) {
    final cached = _topicBox.get(id);
    if (cached != null && !cached.isExpired) {
      return cached;
    }
    _topicBox.delete(id);
    return null;
  }

  // ===== PENDING REQUESTS (for offline sync) =====

  /// Add pending request
  Future<void> addPendingRequest(PendingRequest request) async {
    await _requestBox.put(request.id, request);
  }

  /// Get all pending requests
  List<PendingRequest> getPendingRequests() {
    return _requestBox.values.toList();
  }

  /// Remove pending request after sync
  Future<void> removePendingRequest(String id) async {
    await _requestBox.delete(id);
  }

  /// Clear all pending requests
  Future<void> clearPendingRequests() async {
    await _requestBox.clear();
  }

  // ===== SETTINGS =====

  /// Save setting
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Get setting
  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  /// Get string setting
  String? getStringSetting(String key) {
    return _settingsBox.get(key) as String?;
  }

  /// Get bool setting
  bool? getBoolSetting(String key) {
    return _settingsBox.get(key) as bool?;
  }

  /// Clear settings
  Future<void> clearSettings() async {
    await _settingsBox.clear();
  }

  // ===== CLEANUP =====

  /// Close all boxes
  Future<void> close() async {
    await Hive.close();
    _isInitialized = false;
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _sentenceBox.clear();
    await _topicBox.clear();
    await _requestBox.clear();
    await _settingsBox.clear();
  }
}
