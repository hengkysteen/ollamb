// coverage:ignore-file
class OllamaxModel {
  final String name;
  final String model;
  final String modifiedAt;
  final int size;
  final String digest;
  final OllamaxModelDetails details;

  OllamaxModel({
    required this.name,
    required this.model,
    required this.modifiedAt,
    required this.size,
    required this.digest,
    required this.details,
  });

  String get formatedSize {
    double mb = size / (1000 * 1000);
    double gb = size / (1000 * 1000 * 1000);

    if (gb >= 1) {
      return "${gb.toStringAsFixed(2)} GB";
    } else {
      return "${mb.toStringAsFixed(2)} MB";
    }
  }

  factory OllamaxModel.fromJson(Map<String, dynamic> json) {
    return OllamaxModel(
      name: json['name'],
      model: json['model'],
      modifiedAt: json['modified_at'],
      size: json['size'],
      digest: json['digest'],
      details: OllamaxModelDetails.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'model': model,
      'modified_at': modifiedAt,
      'size': size,
      'digest': digest,
      'details': details.toJson(),
    };
  }
}

class OllamaxModelDetails {
  final String parentModel;
  final String format;
  final String family;
  final List<String> families;
  final String parameterSize;
  final String quantizationLevel;

  OllamaxModelDetails({
    required this.parentModel,
    required this.format,
    required this.family,
    required this.families,
    required this.parameterSize,
    required this.quantizationLevel,
  });

  factory OllamaxModelDetails.fromJson(Map<String, dynamic> json) {
    return OllamaxModelDetails(
      parentModel: json['parent_model'],
      format: json['format'],
      family: json['family'],
      families: List<String>.from(json['families']),
      parameterSize: json['parameter_size'],
      quantizationLevel: json['quantization_level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_model': parentModel,
      'format': format,
      'family': family,
      'families': families,
      'parameter_size': parameterSize,
      'quantization_level': quantizationLevel,
    };
  }
}
