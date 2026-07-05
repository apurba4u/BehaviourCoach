import 'package:discipline_os/core/ai/errors/ai_exception.dart';
import 'package:discipline_os/core/ai/models/ai_response.dart';
import 'package:discipline_os/core/ai/prompts/prompt_manager.dart';
import 'package:discipline_os/core/ai/services/gemini_service.dart';

/// AI Orchestrator
/// Coordinates AI operations and manages prompt execution
class AiOrchestrator {
  final GeminiService _geminiService;
  final PromptManager _promptManager;

  AiOrchestrator({
    required GeminiService geminiService,
    required PromptManager promptManager,
  })  : _geminiService = geminiService,
        _promptManager = promptManager;

  /// Execute a prompt with variables
  Future<AiResponse> executePrompt({
    required String promptName,
    required Map<String, String> variables,
    List<String>? context,
    String version = 'v1',
  }) async {
    try {
      final prompt = await _promptManager.loadAndInterpolate(
        promptName,
        version: version,
        variables: variables,
      );

      return await _geminiService.generateContentWithRetry(
        prompt: prompt,
        context: context,
      );
    } on AiException {
      rethrow;
    } catch (e) {
      throw AiFailureException(message: e.toString());
    }
  }

  /// Execute a prompt and return parsed data
  Future<Map<String, dynamic>> executeAndParse({
    required String promptName,
    required Map<String, String> variables,
    List<String>? context,
    String version = 'v1',
  }) async {
    final response = await executePrompt(
      promptName: promptName,
      variables: variables,
      context: context,
      version: version,
    );

    if (!response.isValidJson) {
      throw AiResponseException(
        rawResponse: response.content,
      );
    }

    return response.asJson!;
  }

  /// Execute with custom prompt text
  Future<AiResponse> executeRawPrompt({
    required String prompt,
    List<String>? context,
  }) {
    return _geminiService.generateContentWithRetry(
      prompt: prompt,
      context: context,
    );
  }
}
