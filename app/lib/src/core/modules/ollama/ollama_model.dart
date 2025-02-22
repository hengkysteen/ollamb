class OllamaServer {
  final OllamaHost host;
  List<OllamaModel> models;

  OllamaServer({required this.host, this.models = const []});

  Map<String, dynamic> toJson() {
    return {'host': host.toJson(), 'models': models.map((model) => model.toJson()).toList()};
  }

  factory OllamaServer.fromJson(Map<String, dynamic> json) {
    return OllamaServer(
      host: OllamaHost.fromJson(json['host']),
      models: (json['models'] as List<dynamic>).map((model) => OllamaModel.fromJson(model)).toList(),
    );
  }
}

class OllamaHost {
  final String name;
  final String url;
  String version;

  OllamaHost({required this.name, required this.url, this.version = ""});

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'version': version};
  }

  factory OllamaHost.fromJson(Map<String, dynamic> json) {
    return OllamaHost(
      name: json['name'],
      url: json['url'],
      version: json['version'] ?? '',
    );
  }
}

class OllamaModel {
  final String name;
  final String size;
  final String family;
  final String quantization;
  final String paramSize;

  OllamaModel({
    required this.name,
    required this.size,
    required this.family,
    required this.quantization,
    required this.paramSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
      'family': family,
      'quantization': quantization,
      'paramSize': paramSize,
    };
  }

  factory OllamaModel.fromJson(Map<String, dynamic> json) {
    return OllamaModel(
      name: json['name'],
      size: json['size'],
      family: json['family'],
      quantization: json['quantization'],
      paramSize: json['paramSize'],
    );
  }
}
