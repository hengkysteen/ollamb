import 'dart:async';
import 'package:get/get.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/core/modules/conversation/models/conversation.dart';
import 'package:ollamb/src/core/modules/conversation/data/conversation_repository.dart';
import '../models/message.dart';
part 'message_ext_vm.dart';

class ConversationVm extends GetxController {
  final ConversationRepository _repository;
  final OllamaRepository _ollamaRepository;

  ConversationVm(this._repository, this._ollamaRepository);

  /// Conversation Meta List
  final List<ConversationMeta> conversationsMeta = [];

  /// Conversations temporary List
  final List<Conversation> conversationsRef = [];

  StreamSubscription<OllamaxChatResponse>? _messageStream;

  /// Current Conversation Message
  Message? message;

  /// Current Conversation
  Conversation? conversation;

  bool isMessageStart = false;

  String generatingTitleId = "";

  List<Message> get messages => conversation!.messages.reversed.toList();

  /// reversed last message
  Message get lastMessage => messages.first;

  String get generateId => DateTime.now().millisecondsSinceEpoch.toString();

  void setConversation(Conversation? data) {
    if (message == null) {
      if (data != null) {
        conversationsRef.removeWhere((e) => e.id != data.id);
        if (!conversationsRef.any((e) => e.id == data.id)) {
          conversationsRef.add(data);
        }
        conversation = conversationsRef.first;
      } else {
        conversation = null;
        conversationsRef.clear();
      }
    } else {
      if (data != null) {
        if (!conversationsRef.any((e) => e.id == data.id)) {
          conversationsRef.add(data);
        }
        conversation = conversationsRef.firstWhere((e) => e.id == data.id);
      } else {
        conversation = conversationsRef.firstWhere((e) => e.id == message?.conversationId);
      }
    }
    update();
  }

  void updateConversationTitle(String id, String title) {
    conversationsMeta.firstWhere((e) => e.id == id).title = title;
    update();
  }

  Future<void> getMetaConversations() async {
    final data = await _repository.getMetaConversations();
    conversationsMeta.clear();
    conversationsMeta.addAll(data);
    update();
  }

  Future<Conversation?> getConversation(String id) async {
    return await _repository.getConversation(id);
  }

  Future<void> deleteConversation(String id) async {
    conversationsMeta.removeWhere((e) => e.id == id);
    update();
    await _repository.deleteConversation(id);
    await getMetaConversations();
  }

  Future<void> updateConversation(Conversation conversation) async {
    await _repository.updateConversation(conversation);
    await getMetaConversations();
  }

  Conversation _createConversation() {
    final data = Conversation(id: generateId, title: "", messages: [], histories: []);
    conversationsMeta.add(ConversationMeta(id: data.id, title: data.title));
    update();
    return data;
  }

  Future<void> save(Conversation conversation) async {
    await _repository.saveConversation(conversation);
    update();
  }

  Future<String> generateTitle(String id, String content, String model) async {
    if (content.length < 5) return "Untitled";

    generatingTitleId = id;
    update();

    final prompt = "Please change 'text' below to a single concise title no more than 4 english words WITHOUT ANSWERING IT.\nONLY RESPONSE IN ENGLISH AND DO NOT RESPONSE MORE THAN 4 ENGLISH WORDS!.\n]nText:\n$content";

    final Map<String, dynamic> body = {
      "model": model,
      "prompt": prompt,
      "stream": false,
      "options": {"num_predict": 20}
    };

    final data = await _ollamaRepository.generate(body);
    final String title = data['response'];
    generatingTitleId = "";
    update();

    return cleanTitle(title);
  }

  String cleanTitle(String value) {
    String cleaned = value.trim().replaceFirst('"', '').replaceFirst('"', '').replaceFirst("'", '').replaceFirst("'", '').replaceAll(":", "");

    List<String> words = cleaned.split(RegExp(r'\s+'));

    if (words.length > 6) {
      words = words.sublist(0, 6);
    }

    return words.join(' ');
  }

  static ConversationVm get find => Get.find();
}
