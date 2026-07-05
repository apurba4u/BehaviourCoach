import 'package:equatable/equatable.dart';

/// AI Response Model
class AiResponse extends Equatable {
  final String content;
  final String? rawContent;
  final Map<String, dynamic>? parsedData;
  final DateTime timestamp;
  final String model;

  const AiResponse({
    required this.content,
    this.rawContent,
    this.parsedData,
    required this.timestamp,
    required this.model,
  });

  /// Parse the response content as JSON
  Map<String, dynamic>? get asJson => parsedData;

  /// Check if the response contains valid JSON
  bool get isValidJson => parsedData != null;

  @override
  List<Object?> get props => [content, rawContent, parsedData, timestamp, model];
}

/// AI Parsed Response with typed data
class AiParsedResponse<T> extends Equatable {
  final T data;
  final String rawContent;
  final DateTime timestamp;
  final String model;

  const AiParsedResponse({
    required this.data,
    required this.rawContent,
    required this.timestamp,
    required this.model,
  });

  @override
  List<Object?> get props => [data, rawContent, timestamp, model];
}
