import 'package:equatable/equatable.dart';

/// AI Failure Types for Either pattern
sealed class AiFailure extends Equatable {
  final String message;
  final String? code;

  const AiFailure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// API key failure
class AiApiKeyFailure extends AiFailure {
  const AiApiKeyFailure({
    super.message = 'Invalid or missing API key',
    super.code = 'API_KEY_INVALID',
  });
}

/// Rate limit failure
class AiRateLimitFailure extends AiFailure {
  const AiRateLimitFailure({
    super.message = 'Rate limit exceeded',
    super.code = 'RATE_LIMIT_EXCEEDED',
  });
}

/// Timeout failure
class AiTimeoutFailure extends AiFailure {
  const AiTimeoutFailure({
    super.message = 'Request timed out',
    super.code = 'REQUEST_TIMEOUT',
  });
}

/// Network failure
class AiNetworkFailure extends AiFailure {
  const AiNetworkFailure({
    super.message = 'Network error',
    super.code = 'NETWORK_ERROR',
  });
}

/// Response parsing failure
class AiResponseFailure extends AiFailure {
  final String? rawResponse;

  const AiResponseFailure({
    super.message = 'Failed to parse AI response',
    super.code = 'INVALID_RESPONSE',
    this.rawResponse,
  });

  @override
  List<Object?> get props => [...super.props, rawResponse];
}

/// Model failure
class AiModelFailure extends AiFailure {
  const AiModelFailure({
    super.message = 'AI model unavailable',
    super.code = 'MODEL_UNAVAILABLE',
  });
}

/// General AI failure
class AiGeneralFailure extends AiFailure {
  const AiGeneralFailure({
    super.message = 'AI service error',
    super.code = 'AI_FAILURE',
  });
}
