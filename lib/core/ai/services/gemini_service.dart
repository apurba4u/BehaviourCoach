import 'dart:async';
import 'dart:convert';

import 'package:discipline_os/config/env_config.dart';
import 'package:discipline_os/core/ai/errors/ai_exception.dart';
import 'package:discipline_os/core/ai/models/ai_response.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Gemini AI Service
/// Handles communication with Google's Gemini API
class GeminiService {
  GenerativeModel? _model;
  bool _initialized = false;

  /// Initialize the Gemini service with API key
  void initialize() {
    final apiKey = EnvConfig.geminiApiKey;

    if (apiKey.isEmpty) {
      throw const AiApiKeyException();
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
        responseMimeType: 'application/json',
      ),
    );

    _initialized = true;
  }

  /// Ensure the service is initialized
  void _ensureInitialized() {
    if (!_initialized || _model == null) {
      initialize();
    }
  }

  /// Generate content from a prompt
  Future<AiResponse> generateContent({
    required String prompt,
    List<String>? context,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    _ensureInitialized();

    try {
      final content = [Content.text(prompt)];

      if (context != null && context.isNotEmpty) {
        content.insert(0, Content.text(context.join('\n\n')));
      }

      final response = await _model!.generateContent(content).timeout(timeout);

      if (response.text == null || response.text!.isEmpty) {
        throw const AiResponseException();
      }

      final parsedData = _parseResponse(response.text!);

      return AiResponse(
        content: response.text!,
        rawContent: response.text,
        parsedData: parsedData,
        timestamp: DateTime.now(),
        model: 'gemini-2.0-flash',
      );
    } on TimeoutException {
      throw const AiTimeoutException();
    } on AiException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('API_KEY_INVALID') ||
          e.toString().contains('401')) {
        throw const AiApiKeyException();
      }
      if (e.toString().contains('RESOURCE_EXHAUSTED') ||
          e.toString().contains('429')) {
        throw const AiRateLimitException();
      }
      throw AiFailureException(message: e.toString());
    }
  }

  /// Generate content with retry logic
  Future<AiResponse> generateContentWithRetry({
    required String prompt,
    List<String>? context,
    int maxRetries = 3,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    var attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await generateContent(
          prompt: prompt,
          context: context,
          timeout: timeout,
        );
      } on AiRateLimitException {
        attempts++;
        if (attempts >= maxRetries) rethrow;
        await Future<void>.delayed(Duration(seconds: attempts * 2));
      } on AiTimeoutException {
        attempts++;
        if (attempts >= maxRetries) rethrow;
      } on AiApiKeyException {
        rethrow;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) rethrow;
      }
    }

    throw const AiFailureException(message: 'Max retries exceeded');
  }

  /// Parse JSON response from text
  Map<String, dynamic>? _parseResponse(String text) {
    try {
      // Try to find JSON in the response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _model = null;
    _initialized = false;
  }
}
