class ValidationResult {
  final bool faceSizeOk;
  final bool backgroundOk;
  final bool lightingOk;
  final bool expressionOk;
  final bool sharpnessOk;
  final bool shadowFree;
  final int score;
  final List<String> errors;
  final List<String> suggestions;

  const ValidationResult({
    this.faceSizeOk = false,
    this.backgroundOk = false,
    this.lightingOk = false,
    this.expressionOk = false,
    this.sharpnessOk = false,
    this.shadowFree = false,
    this.score = 0,
    this.errors = const [],
    this.suggestions = const [],
  });

  int get passedChecks => [
        faceSizeOk,
        backgroundOk,
        lightingOk,
        expressionOk,
        sharpnessOk,
        shadowFree,
      ].where((v) => v).length;

  int get totalChecks => 6;

  bool get allPassed => passedChecks == totalChecks;

  ValidationResult copyWith({
    bool? faceSizeOk,
    bool? backgroundOk,
    bool? lightingOk,
    bool? expressionOk,
    bool? sharpnessOk,
    bool? shadowFree,
    int? score,
    List<String>? errors,
    List<String>? suggestions,
  }) {
    return ValidationResult(
      faceSizeOk: faceSizeOk ?? this.faceSizeOk,
      backgroundOk: backgroundOk ?? this.backgroundOk,
      lightingOk: lightingOk ?? this.lightingOk,
      expressionOk: expressionOk ?? this.expressionOk,
      sharpnessOk: sharpnessOk ?? this.sharpnessOk,
      shadowFree: shadowFree ?? this.shadowFree,
      score: score ?? this.score,
      errors: errors ?? this.errors,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
