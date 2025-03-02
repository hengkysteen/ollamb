class Prompt {
  String id;
  String type;
  String name;
  String prompt;

  Prompt({required this.id, required this.type, required this.name, required this.prompt});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'type': type,
      'name': name,
      'prompt': prompt,
    };
  }

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      prompt: json['prompt'] as String,
    );
  }
}
