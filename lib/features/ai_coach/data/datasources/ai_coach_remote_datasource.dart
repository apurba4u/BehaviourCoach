import 'package:discipline_os/core/ai/errors/ai_exception.dart';
import 'package:discipline_os/core/ai/models/ai_response.dart';
import 'package:discipline_os/core/ai/services/ai_orchestrator.dart';
import 'package:discipline_os/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiCoachRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final AiOrchestrator _aiOrchestrator;

  AiCoachRemoteDataSource({
    SupabaseClient? supabaseClient,
    required AiOrchestrator aiOrchestrator,
  })  : _supabaseClient = supabaseClient ?? Supabase.instance.client,
        _aiOrchestrator = aiOrchestrator;

  Future<Map<String, dynamic>> createConversation({
    required String userId,
    required String conversationId,
  }) async {
    final now = DateTime.now().toIso8601String();
    final response = await _supabaseClient
        .from('ai_coach_conversations')
        .insert({
          'id': conversationId,
          'user_id': userId,
          'created_at': now,
          'updated_at': now,
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getConversations({
    required String userId,
    int? limit,
    int? offset,
  }) async {
    var query = _supabaseClient
        .from('ai_coach_conversations')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }
    if (offset != null) {
      query = query.range(offset, offset + (limit ?? 20) - 1);
    }

    final response = await query;
    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getConversation(
    String conversationId,
  ) async {
    final response = await _supabaseClient
        .from('ai_coach_conversations')
        .select()
        .eq('id', conversationId)
        .single();
    return response;
  }

  Future<void> insertMessage({
    required String conversationId,
    required String messageId,
    required String content,
    required String role,
  }) async {
    await _supabaseClient.from('ai_coach_messages').insert({
      'id': messageId,
      'conversation_id': conversationId,
      'content': content,
      'role': role,
      'created_at': DateTime.now().toIso8601String(),
    });
    await _supabaseClient.from('ai_coach_conversations').update({
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', conversationId);
  }

  Future<List<Map<String, dynamic>>> getMessages(
    String conversationId,
  ) async {
    final response = await _supabaseClient
        .from('ai_coach_messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<AiResponse> generateAiResponse({
    required List<Map<String, String>> conversationHistory,
  }) async {
    final historyText = conversationHistory
        .map((m) => '${m['role']}: ${m['content']}')
        .join('\n');

    try {
      final response = await _aiOrchestrator.executeRawPrompt(
        prompt: 'You are a supportive AI behavioral coach. '
            'Help the user build better habits and maintain discipline. '
            'Be encouraging, specific, and actionable.\n\n'
            'Conversation history:\n$historyText\n\n'
            'Respond as the AI coach:',
      );
      return response;
    } on AiException catch (e) {
      Logger.error('AI response generation failed', error: e);
      rethrow;
    }
  }
}
