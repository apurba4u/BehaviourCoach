import 'package:equatable/equatable.dart';

/// AI Insight Entity
class AiInsight extends Equatable {
  final String id;
  final String type;
  final String title;
  final String insight;
  final String? actionableTip;
  final double confidence;
  final String category;
  final DateTime generatedAt;
  final Map<String, dynamic>? metadata;

  const AiInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.insight,
    this.actionableTip,
    this.confidence = 0.0,
    required this.category,
    required this.generatedAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        insight,
        actionableTip,
        confidence,
        category,
        generatedAt,
        metadata,
      ];
}

/// AI Recommendation Entity
class AiRecommendation extends Equatable {
  final String action;
  final String reason;
  final String priority;
  final String? expectedImpact;
  final String? timeEstimate;

  const AiRecommendation({
    required this.action,
    required this.reason,
    required this.priority,
    this.expectedImpact,
    this.timeEstimate,
  });

  @override
  List<Object?> get props => [action, reason, priority, expectedImpact, timeEstimate];
}

/// AI Pattern Entity
class AiPattern extends Equatable {
  final String pattern;
  final String type;
  final String frequency;
  final double confidence;
  final String impact;
  final List<String> evidence;

  const AiPattern({
    required this.pattern,
    required this.type,
    required this.frequency,
    required this.confidence,
    required this.impact,
    required this.evidence,
  });

  @override
  List<Object?> get props => [pattern, type, frequency, confidence, impact, evidence];
}

/// AI Summary Entity
class AiSummary extends Equatable {
  final String summary;
  final List<String> highlights;
  final List<String> challenges;
  final List<AiPattern> patterns;
  final List<AiRecommendation> recommendations;
  final String scoreTrend;
  final double consistencyPercentage;

  const AiSummary({
    required this.summary,
    required this.highlights,
    required this.challenges,
    required this.patterns,
    required this.recommendations,
    required this.scoreTrend,
    required this.consistencyPercentage,
  });

  @override
  List<Object?> get props => [
        summary,
        highlights,
        challenges,
        patterns,
        recommendations,
        scoreTrend,
        consistencyPercentage,
      ];
}
