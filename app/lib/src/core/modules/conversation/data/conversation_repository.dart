import 'package:ollamb/src/core/modules/conversation/data/conversation_storage.dart';
import '../models/conversation.dart';

class ConversationRepository {
  final ConversationStorage _storage;

  ConversationRepository(this._storage);

  Future<void> saveConversation(Conversation conversation) async {
    _storage.save(conversation.toJson());
  }

  Future<Conversation?> getConversation(String id) async {
    final data = await _storage.get(id);
    if (data == null) return null;
    return Conversation.fromJson(data);
  }

  Future<void> deleteConversation(String id) async {
    await _storage.delete(id);
  }

  Future<List<ConversationMeta>> getMetaConversations() async {
    final data = await _storage.getList();
    if (data.isEmpty) return [];
    return data.map((e) => ConversationMeta(id: e['id'], title: e['title'])).toList();
  }

  Future<void> updateConversation(Conversation conversation) async {
    await _storage.update(conversation.toJson(), conversation.id);
  }
}
