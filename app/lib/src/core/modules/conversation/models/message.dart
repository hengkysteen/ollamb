import 'package:ollamax/ollamax.dart';

class Message {
  final String id;
  final String conversationId;
  final Prompt prompt;
  final String model;
  OllamaxChatResponse? response;
  String content;
  bool isDone;
  Map<String, dynamic>? data;

  Message({
    required this.id,
    required this.prompt,
    required this.model,
    this.response,
    required this.content,
    this.isDone = false,
    required this.conversationId,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt.toJson(),
      'model': model,
      'response': response?.toJson(),
      'content': content,
      'is_done': isDone,
      'conversation_id': conversationId,
       'data': data
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      prompt: Prompt.fromJson(json['prompt']),
      model: json['model'],
      response: json['response'] != null ? OllamaxChatResponse.fromJson(json['response']) : null,
      content: json['content'],
      isDone: json['is_done'],
      conversationId: json['conversation_id'],
      data: json['data'],
    );
  }
}

class Prompt {
  final String text;
  String? image;
  Map<String, dynamic>? document;
  Prompt({required this.text, this.image, this.document});

  Map<String, dynamic> toJson() {
    return {'text': text, 'image': image, 'document': document};
  }

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      text: json['text'],
      image: json['image'],
      document: json['document'],
    );
  }
}

class MessageHistory {
  final String conversationId;
  final String messageId;
  final OllamaxMessage message;
  final String label;

  MessageHistory({
    required this.conversationId,
    required this.messageId,
    required this.message,
    this.label = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'messageId': messageId,
      'message': message.toJson(),
      'label': label,
    };
  }

  factory MessageHistory.fromJson(Map<String, dynamic> json) {
    return MessageHistory(
      conversationId: json['conversationId'],
      messageId: json['messageId'],
      message: OllamaxMessage.fromJson(json['message']),
      label: json['label'],
    );
  }
}
