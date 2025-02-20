import 'package:ollamax/ollamax.dart';

final model1 = OllamaxModel(
  name: "model1",
  model: "model1",
  modifiedAt: "123123",
  size: 1,
  digest: "digest",
  details: OllamaxModelDetails(
    parentModel: "parentModel",
    format: "format",
    family: "family",
    families: ["A"],
    parameterSize: "1b",
    quantizationLevel: "A",
  ),
);

final streamResponse = [
  OllamaxChatResponse(
    model: "model",
    createdAt: "createdAt1",
    message: OllamaxMessage(role: "assistant", content: "Hi"),
    done: false,
  ),
  OllamaxChatResponse(
    model: "model",
    createdAt: "createdAt2",
    message: OllamaxMessage(role: "assistant", content: "How"),
    done: false,
  ),
  OllamaxChatResponse(
    model: "model",
    createdAt: "createdAt3",
    message: OllamaxMessage(role: "assistant", content: "are you?"),
    done: true,
  ),
];
