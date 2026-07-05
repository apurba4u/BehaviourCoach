import 'package:equatable/equatable.dart';

/// AI Insight Entity
class AiInsightEntity extends Equatable {
  final String id;
  final String userId;
  final String insightType;
  final String title;
  final String content;
  final double? confidenceScore;
  final Map<String, dynamic> metadata;
  final bool isRead;
  final bool isDismissed;
  final DateTime generatedAt;
  final DateTime createdAt;

  const AiInsightEntity({
    required this.id,
    required this.userId,
    required this.insightType,
    required this.title,
    required this.content,
    this.confidenceScore,
    this.metadata = const {},
    this.isRead = false,
    this.isDismissed = false,
    required this.generatedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        insightType,
        title,
        content,
        confidenceScore,
        metadata,
        isRead,
        isDismissed,
        generatedAt,
        createdAt,
      ];
}
