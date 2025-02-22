part of 'conversation_vm.dart';

extension ConversationMessageVm on ConversationVm {

  
  Message _createMessage(Prompt prompt, String model) {
    final data = Message(conversationId: conversation!.id, id: generateId, prompt: prompt, model: model, content: "");
    conversation!.messages.add(data);
    update();
    return conversation!.messages.firstWhere((e) => e.id == data.id);
  }

  List<MessageHistory> _getMessageHistories(Prompt prompt, {String? system}) {
    final data = OllamaxMessage(role: 'user', content: prompt.text, images: prompt.image == null ? null : [prompt.image!]);
    final List<MessageHistory> histories = [MessageHistory(messageId: message!.id, conversationId: conversation!.id, message: data)];

    if (prompt.document != null) {
      final data = OllamaxMessage(role: 'user', content: documentTemplate(prompt.document!['name'], prompt.document!['content']));
      final document = MessageHistory(messageId: message!.id, conversationId: conversation!.id, message: data);
      histories.insert(0, document);
    }

    if (system != null && system.trim().isNotEmpty && !conversation!.histories.any((e) => e.message.role == 'system')) {
      final data = OllamaxMessage(role: 'system', content: system);
      conversation!.histories.add(MessageHistory(messageId: message!.id, conversationId: conversation!.id, message: data));
    }
    return histories;
  }

  Future<void> deleteMessage(Message message) async {
    conversation!.histories.where((e) => e.message.role != "system");
    conversation!.histories.removeWhere((e) => e.messageId == message.id);
    conversation!.messages.removeWhere((e) => e.id == message.id);
    update();
    await updateConversation(conversation!);
  }

  void sendMessage(
    Prompt prompt,
    String model, {
    String? system,
    OllamaxOptions? options,
    String? keepAlive,
    void Function(Conversation data)? onConversationCreate,
  }) async {
    if (conversation == null) {
      final data = _createConversation();
      conversationsRef.add(data);
      conversation = conversationsRef.firstWhere((e) => e.id == data.id);
    }

    onConversationCreate?.call(conversation!);
    isMessageStart = true;
    message = _createMessage(prompt, model);
    final userPrompt = _getMessageHistories(prompt, system: system);
    conversation!.histories.addAll(userPrompt);
    update();

    final request = OllamaxChatRequest(
      model: model,
      messages: conversation!.histories.map((e) => e.message).toList(),
      options: options,
      keepAlive: keepAlive,
    );

    final Stream<OllamaxChatResponse> chat = await _ollamaRepository.chat(request);

    _messageStream = chat.listen((response) {
      message!.content += response.message.content;
      message!.response = response;
      update();
    }, onDone: () async {
      stopMessage();
    }, onError: (error) {
      message!.content = error.toString();
      stopMessage();
    }, cancelOnError: true);
  }

  void stopMessage() async {
    isMessageStart = false;
    _messageStream?.cancel();
    _messageStream = null;
    message!.isDone = true;

    if (message!.response == null) {
      if (message!.content.isEmpty) {
        message!.content = "Canceled";
        message = null;
        update();
        if (conversation!.messages.length > 1) {
          message = null;
          update();
          return;
        }
      } else {
        if (conversation!.messages.length > 1) {
          message = null;
          update();
          return;
        }
      }
    } else {
      if (message!.response!.doneReason == "error") {
        if (message!.prompt.image != null) {
          conversation!.histories.removeLast();
          update();
        }
      } else {
        final assistant = OllamaxMessage(role: 'assistant', content: message!.content);
        conversation!.histories.add(
          MessageHistory(conversationId: conversation!.id, messageId: message!.id, message: assistant),
        );
      }
    }

    if (message == null) return;

    final updateConversation = conversationsRef.firstWhere((e) => e.id == message!.conversationId);

    if (updateConversation.title.isEmpty) {
      final prompt = message!.prompt.text;
      final model = message!.model;
      final id = updateConversation.id;
      ConversationVm.find.generateTitle(id, prompt, model).then((title) async {
        updateConversation.title = title;
        ConversationVm.find.updateConversationTitle(id, title);
        await ConversationVm.find.save(updateConversation);
      });
      message = null;

      update();
      return;
    }

    message = null;
    update();
    ConversationVm.find.save(updateConversation);
  }

  String documentTemplate(String fileName, String content) {
    return """
Read this Document.
file name : $fileName
file content:
$content
.
Use document above to answer my next question. 
make sure your response same language as next question.
""";
  }
}
