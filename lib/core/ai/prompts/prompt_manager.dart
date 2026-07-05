import 'package:flutter/services.dart';

/// Prompt Manager - loads and manages prompt templates
class PromptManager {
  static PromptManager? _instance;
  static final Map<String, String> _cache = {};

  PromptManager._();

  /// Singleton instance
  static PromptManager get instance {
    _instance ??= PromptManager._();
    return _instance!;
  }

  /// Load a prompt template from the prompts directory
  Future<String> loadPrompt(String promptName, {String version = 'v1'}) async {
    final cacheKey = '$version/$promptName';

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final path = 'core/ai/prompts/$version/$promptName.md';
      final content = await rootBundle.loadString(path);
      _cache[cacheKey] = content;
      return content;
    } catch (e) {
      throw PromptNotFoundException(
        'Prompt not found: $version/$promptName',
      );
    }
  }

  /// Load and interpolate a prompt template
  Future<String> loadAndInterpolate(
    String promptName, {
    String version = 'v1',
    required Map<String, String> variables,
  }) async {
    var content = await loadPrompt(promptName, version: version);

    for (final entry in variables.entries) {
      content = content.replaceAll('{{${entry.key}}}', entry.value);
    }

    return content;
  }

  /// Clear the prompt cache
  void clearCache() {
    _cache.clear();
  }

  /// Check if a prompt exists
  Future<bool> promptExists(String promptName, {String version = 'v1'}) async {
    try {
      await loadPrompt(promptName, version: version);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Exception thrown when a prompt is not found
class PromptNotFoundException implements Exception {
  final String message;

  const PromptNotFoundException(this.message);

  @override
  String toString() => 'PromptNotFoundException: $message';
}
