/// DTOs cho Review API (Spaced Repetition)
/// Khớp với response từ GET /api/v1/review/today và POST /api/v1/review/submit

/// Thông tin chi tiết một câu cần ôn tập hôm nay
class ReviewItemDto {
  final String id;
  final String sentenceId;
  final String englishText;
  final String vietnameseText;   // mapped từ vietnameseseText trong API
  final String? audioUrl;
  final String? topicName;
  final String difficultyLevel;
  final int interval;             // số ngày tới lần ôn tiếp theo
  final int repetitions;          // số lần đã ôn
  final double easeFactor;        // hệ số dễ SM-2
  final DateTime? nextReviewDate;
  final DateTime? lastReviewedAt;

  ReviewItemDto({
    required this.id,
    required this.sentenceId,
    required this.englishText,
    required this.vietnameseText,
    this.audioUrl,
    this.topicName,
    required this.difficultyLevel,
    required this.interval,
    required this.repetitions,
    required this.easeFactor,
    this.nextReviewDate,
    this.lastReviewedAt,
  });

  factory ReviewItemDto.fromJson(Map<String, dynamic> json) {
    // Lấy sentence data — có thể nằm trong nested 'sentence' object
    final sentence = json['sentence'] as Map<String, dynamic>? ?? json;
    final englishText = sentence['englishText'] as String? ??
        json['englishText'] as String? ??
        '';
    final vietnameseText =
        sentence['vietnameseseText'] as String? ??
        sentence['vietnameseText'] as String? ??
        json['vietnameseseText'] as String? ??
        json['vietnameseText'] as String? ??
        '';

    // Tìm audio URL trong medias array
    String? audioUrl;
    final medias = (sentence['medias'] as List<dynamic>?) ??
        (json['medias'] as List<dynamic>?) ?? [];
    for (final m in medias) {
      final media = m as Map<String, dynamic>;
      if (media['mediaType'] == 'audio' &&
          (media['isApproved'] == true || media['isApproved'] == null)) {
        audioUrl = media['mediaUrl'] as String?;
        break;
      }
    }

    // Topic name
    final topic = sentence['topic'] as Map<String, dynamic>? ??
        json['topic'] as Map<String, dynamic>?;
    final topicName = topic?['name'] as String?;

    return ReviewItemDto(
      id: json['id'] as String? ?? '',
      sentenceId: json['sentenceId'] as String? ??
          sentence['id'] as String? ?? '',
      englishText: englishText,
      vietnameseText: vietnameseText,
      audioUrl: audioUrl,
      topicName: topicName,
      difficultyLevel: sentence['difficultyLevel'] as String? ??
          json['difficultyLevel'] as String? ?? 'medium',
      interval: json['interval'] as int? ?? 1,
      repetitions: json['repetitions'] as int? ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      nextReviewDate: _parseDate(json['nextReviewDate']),
      lastReviewedAt: _parseDate(json['lastReviewedAt']),
    );
  }

  static DateTime? _parseDate(dynamic val) {
    if (val == null) return null;
    try {
      return DateTime.parse(val as String);
    } catch (_) {
      return null;
    }
  }
}

/// Response từ GET /api/v1/review/today
class ReviewTodayResponseDto {
  final List<ReviewItemDto> items;
  final int totalDue;
  final int reviewedToday;
  final int masteredCount;

  ReviewTodayResponseDto({
    required this.items,
    required this.totalDue,
    required this.reviewedToday,
    required this.masteredCount,
  });

  factory ReviewTodayResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((e) => ReviewItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return ReviewTodayResponseDto(
      items: items,
      totalDue: json['totalDue'] as int? ??
          json['totalCount'] as int? ??
          items.length,
      reviewedToday: json['reviewedToday'] as int? ?? 0,
      masteredCount: json['masteredCount'] as int? ?? 0,
    );
  }
}

/// Response từ POST /api/v1/review/submit
class SubmitReviewResponseDto {
  final String scheduleId;
  final int newInterval;         // số ngày tới lần ôn tiếp theo
  final double newEaseFactor;
  final int newRepetitions;
  final DateTime nextReviewDate;
  final int pointsEarned;
  final String message;

  SubmitReviewResponseDto({
    required this.scheduleId,
    required this.newInterval,
    required this.newEaseFactor,
    required this.newRepetitions,
    required this.nextReviewDate,
    required this.pointsEarned,
    required this.message,
  });

  factory SubmitReviewResponseDto.fromJson(Map<String, dynamic> json) {
    // Có thể nằm trong nested 'schedule' object
    final schedule = json['schedule'] as Map<String, dynamic>? ?? json;

    return SubmitReviewResponseDto(
      scheduleId: schedule['id'] as String? ?? '',
      newInterval: schedule['interval'] as int? ?? 1,
      newEaseFactor: (schedule['easeFactor'] as num?)?.toDouble() ?? 2.5,
      newRepetitions: schedule['repetitions'] as int? ?? 1,
      nextReviewDate: DateTime.tryParse(
              schedule['nextReviewDate'] as String? ?? '') ??
          DateTime.now().add(const Duration(days: 1)),
      pointsEarned: json['pointsEarned'] as int? ?? 5,
      message: json['message'] as String? ?? 'Đã ghi nhận kết quả',
    );
  }
}
