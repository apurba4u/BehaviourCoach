/// AI Service Exceptions
sealed class AiException implements Exception {
  final String message;
  final String? code;

  const AiException({required this.message, this.code});

  @override
  String toString() => 'AiException: $message';
}

/// API key is invalid or missing
class AiApiKeyException extends AiException {
  const AiApiKeyException({
    super.message = 'Invalid or missing API key',
    super.code = 'API_KEY_INVALID',
  });
}

/// Rate limit exceeded
class AiRateLimitException extends AiException {
  const AiRateLimitException({
    super.message = 'Rate limit exceeded. Please try again later.',
    super.code = 'RATE_LIMIT_EXCEEDED',
  });
}

/// Request timeout
class AiTimeoutException extends AiException {
  const AiTimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.code = 'REQUEST_TIMEOUT',
  });
}

/// Network connection error
class AiNetworkException extends AiException {
  const AiNetworkException({
    super.message = 'Network error. Please check your connection.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Invalid response from AI
class AiResponseException extends AiException {
  final String? rawResponse;

  const AiResponseException({
    super.message = 'Invalid response from AI service',
    super.code = 'INVALID_RESPONSE',
    this.rawResponse,
  });
}

/// Model not available
class AiModelException extends AiException {
  const AiModelException({
    super.message = 'AI model is not available',
    super.code = 'MODEL_UNAVAILABLE',
  });
}

/// General AI failure
class AiFailureException extends AiException {
  const AiFailureException({
    super.message = 'AI service error occurred',
    super.code = 'AI_FAILURE',
  });
}
