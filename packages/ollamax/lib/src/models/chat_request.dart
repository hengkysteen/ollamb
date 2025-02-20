// coverage:ignore-file
import 'index.dart';

class OllamaxChatRequest {
  final String model;
  final List<OllamaxMessage> messages;
  final List<Map<String, dynamic>>? tools;
  final dynamic format;
  final OllamaxOptions? options;
  final bool stream;
  final String? keepAlive;

  OllamaxChatRequest({
    required this.model,
    required this.messages,
    this.tools,
    this.format,
    this.options,
    this.stream = true,
    this.keepAlive,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((m) => m.toJson()).toList(),
      'tools': tools,
      'format': format,
      'options': options?.toJson(),
      'stream': stream,
      'keep_alive': keepAlive,
    };
  }

  factory OllamaxChatRequest.fromJson(Map<String, dynamic> json) {
    return OllamaxChatRequest(
      model: json['model'],
      messages: (json['messages'] as List).map((m) => OllamaxMessage.fromJson(m)).toList(),
      tools: json['tools'],
      format: json['format'],
      options: json['options'] != null ? OllamaxOptions.fromJson(json['options']) : null,
      stream: json['stream'] ?? false,
      keepAlive: json['keep_alive'],
    );
  }
}

class OllamaxTool {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  OllamaxTool({
    required this.name,
    required this.description,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'parameters': parameters,
    };
  }

  factory OllamaxTool.fromJson(Map<String, dynamic> json) {
    return OllamaxTool(
      name: json['name'] as String,
      description: json['description'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
    );
  }
}
