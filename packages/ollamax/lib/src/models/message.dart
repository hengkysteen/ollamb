// coverage:ignore-file
class OllamaxMessage {
  final String role;
  final String content;
  List<String>? images;
  List<Map<String, dynamic>>? toolCalls;

  OllamaxMessage({required this.role, required this.content, this.images, this.toolCalls});

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'images': images,
      'tool_calls': toolCalls,
    };
  }

  factory OllamaxMessage.fromJson(Map<String, dynamic> json) {
    return OllamaxMessage(
      role: json['role'] as String,
      content: json['content'] as String,
      images: (json['images'] as List?)?.cast<String>(),
      toolCalls: (json['tool_calls'] as List?)?.map((e) => e as Map<String, dynamic>).toList(),
    );
  }
}
