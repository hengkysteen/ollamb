// coverage:ignore-file
class OllamaxOptions {
  int? mirostat;
  double? mirostatEta;
  double? mirostatTau;
  int? numCtx;
  int? repeatLastN;
  double? repeatPenalty;
  double? temperature;
  int? seed;
  String? stop;
  double? tfsZ;
  int? numPredict;
  int? topK;
  double? topP;
  double? minP;

  OllamaxOptions({
    this.mirostat,
    this.mirostatEta,
    this.mirostatTau,
    this.numCtx,
    this.repeatLastN,
    this.repeatPenalty,
    this.temperature,
    this.seed,
    this.stop,
    this.tfsZ,
    this.numPredict,
    this.topK,
    this.topP,
    this.minP,
  });
  Map<String, dynamic> toJson() {
    return {
      'mirostat': mirostat,
      'mirostat_eta': mirostatEta,
      'mirostat_tau': mirostatTau,
      'num_ctx': numCtx,
      'repeat_last_n': repeatLastN,
      'repeat_penalty': repeatPenalty,
      'temperature': temperature,
      'seed': seed,
      'stop': stop,
      'tfs_z': tfsZ,
      'num_predict': numPredict,
      'top_k': topK,
      'top_p': topP,
      'min_p': minP,
    };
  }

  OllamaxOptions copyFrom(OllamaxOptions other) {
    return OllamaxOptions(
      mirostat: other.mirostat ?? mirostat,
      mirostatEta: other.mirostatEta ?? mirostatEta,
      mirostatTau: other.mirostatTau ?? mirostatTau,
      numCtx: other.numCtx,
      repeatLastN: other.repeatLastN ?? repeatLastN,
      repeatPenalty: other.repeatPenalty ?? repeatPenalty,
      temperature: other.temperature ?? temperature,
      seed: other.seed ?? seed,
      stop: other.stop ?? stop,
      tfsZ: other.tfsZ ?? tfsZ,
      numPredict: other.numPredict ?? numPredict,
      topK: other.topK ?? topK,
      topP: other.topP ?? topP,
      minP: other.minP ?? minP,
    );
  }

  factory OllamaxOptions.fromJson(Map<String, dynamic> json) {
    return OllamaxOptions(
      mirostat: json['mirostat'] as int?,
      mirostatEta: (json['mirostat_eta'] as num?)?.toDouble(),
      mirostatTau: (json['mirostat_tau'] as num?)?.toDouble(),
      numCtx: json['num_ctx'],
      repeatLastN: json['repeat_last_n'] as int?,
      repeatPenalty: (json['repeat_penalty'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      seed: json['seed'] as int?,
      stop: json['stop'] as String?,
      tfsZ: (json['tfs_z'] as num?)?.toDouble(),
      numPredict: json['num_predict'] as int?,
      topK: json['top_k'] as int?,
      topP: (json['top_p'] as num?)?.toDouble(),
      minP: (json['min_p'] as num?)?.toDouble(),
    );
  }
}
