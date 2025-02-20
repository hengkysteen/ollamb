// coverage:ignore-file
import 'index.dart';

class OllamaxChatResponse {
  final String model;
  final String createdAt;
  final OllamaxMessage message;
  final bool done;
  final String? doneReason;
  final int? totalDuration;
  final int? loadDuration;
  final int? promptEvalCount;
  final int? promptEvalDuration;
  final int? evalCount;
  final int? evalDuration;

  OllamaxChatResponse({
    required this.model,
    required this.createdAt,
    required this.message,
    required this.done,
    this.doneReason,
    this.totalDuration,
    this.loadDuration,
    this.promptEvalCount,
    this.promptEvalDuration,
    this.evalCount,
    this.evalDuration,
  });

  Map<String, dynamic> toJson() {
    final data = {'model': model, 'created_at': createdAt, 'message': message.toJson(), 'done': done};
    if (done) {
      if (doneReason != null) data['done_reason'] = doneReason!;
      if (totalDuration != null) data['total_duration'] = totalDuration!;
      if (loadDuration != null) data['load_duration'] = loadDuration!;
      if (promptEvalCount != null) data['prompt_eval_count'] = promptEvalCount!;
      if (promptEvalDuration != null) data['prompt_eval_duration'] = promptEvalDuration!;
      if (evalCount != null) data['eval_count'] = evalCount!;
      if (evalDuration != null) data['eval_duration'] = evalDuration!;
    }
    return data;
  }

  factory OllamaxChatResponse.fromJson(Map<String, dynamic> json) {
    return OllamaxChatResponse(
      model: json['model'],
      createdAt: json['created_at'],
      message: OllamaxMessage.fromJson(json['message']),
      done: json['done'],
      doneReason: json['done'] == true ? json['done_reason'] : null,
      totalDuration: json['done'] == true ? json['total_duration'] : null,
      loadDuration: json['done'] == true ? json['load_duration'] : null,
      promptEvalCount: json['done'] == true ? json['prompt_eval_count'] : null,
      promptEvalDuration: json['done'] == true ? json['prompt_eval_duration'] : null,
      evalCount: json['done'] == true ? json['eval_count'] : null,
      evalDuration: json['done'] == true ? json['eval_duration'] : null,
    );
  }
}
