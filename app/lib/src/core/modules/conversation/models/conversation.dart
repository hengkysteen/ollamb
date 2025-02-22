import 'message.dart';

class Conversation {
  final String id;
  String title;
  final List<Message> messages;
  final List<MessageHistory> histories;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.histories,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((message) => message.toJson()).toList(),
      'histories': histories.map((e) => e.toJson()).toList(),
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var messagesList = json['messages'] as List;
    var histories = json['histories'] as List;

    return Conversation(
      id: json['id'],
      title: json['title'],
      messages: messagesList.map((msg) => Message.fromJson(msg)).toList(),
      histories: histories.map((e) => MessageHistory.fromJson(e)).toList(),
    );
  }
}

class ConversationMeta {
  final String id;
  String title;
  ConversationMeta({required this.id, required this.title});

  Map<String, dynamic> toJson() => {'id': id, 'title': title};

  factory ConversationMeta.fromJson(Map<String, dynamic> json) {
    return ConversationMeta(id: json['id'], title: json['title']);
  }
}
