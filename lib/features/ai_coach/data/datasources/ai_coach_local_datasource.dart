import 'package:discipline_os/core/local/cache/cache_manager.dart';
import 'package:discipline_os/core/local/adapters/ai_coach_adapter.dart'
    as local;
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_conversation.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_message.dart';

class AiCoachLocalDataSource {
  final CacheManager _cacheManager;

  AiCoachLocalDataSource({CacheManager? cacheManager})
      : _cacheManager = cacheManager ?? CacheManager.instance;

  Future<void> cacheConversation(AiCoachConversation conversation) async {
    final cache = _convertToCache(conversation);
    await _cacheManager.cacheAiCoachConversation(cache);
  }

  AiCoachConversation? getCachedConversation(String conversationId) {
    final cached = _cacheManager.getCachedAiCoachConversation(conversationId);
    if (cached == null) return null;
    return _convertToEntity(cached);
  }

  List<AiCoachConversation> getCachedConversationsByUser(String userId) {
    final cached = _cacheManager.getCachedAiCoachConversationsByUser(userId);
    return cached.map(_convertToEntity).toList();
  }

  Future<void> deleteConversation(String conversationId) async {
    await _cacheManager.deleteAiCoachConversation(conversationId);
  }

  local.AiCoachConversationCache _convertToCache(
    AiCoachConversation conversation,
  ) {
    return local.AiCoachConversationCache(
      id: conversation.id,
      userId: conversation.userId,
      messages: conversation.messages
          .map(
            (m) => local.AiCoachMessageCache(
              id: m.id,
              content: m.content,
              role: m.role.name,
              timestamp: m.timestamp,
            ),
          )
          .toList(),
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
    );
  }

  AiCoachConversation _convertToEntity(
    local.AiCoachConversationCache cache,
  ) {
    return AiCoachConversation(
      id: cache.id,
      userId: cache.userId,
      messages: cache.messages
          .map(
            (m) => AiCoachMessage(
              id: m.id,
              content: m.content,
              role: AiCoachMessageRole.values.firstWhere(
                (r) => r.name == m.role,
                orElse: () => AiCoachMessageRole.user,
              ),
              timestamp: m.timestamp,
            ),
          )
          .toList(),
      createdAt: cache.createdAt,
      updatedAt: cache.updatedAt,
    );
  }
}
