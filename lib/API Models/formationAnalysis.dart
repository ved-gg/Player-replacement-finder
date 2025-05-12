class FormationAnalysis {
  final String player;
  final String position;
  final List<FormationResult> results;

  FormationAnalysis({
    required this.player,
    required this.position,
    required this.results,
  });

  factory FormationAnalysis.fromJson(Map<String, dynamic> json) {
    return FormationAnalysis(
      player: json['player'],
      position: json['position'],
      results: List<FormationResult>.from(
          json['results'].map((x) => FormationResult.fromJson(x))),
    );
  }
}

class FormationResult {
  final String explanation;
  final String formation;
  final String position;
  final double score;
  final String style;

  FormationResult({
    required this.explanation,
    required this.formation,
    required this.position,
    required this.score,
    required this.style,
  });

  factory FormationResult.fromJson(Map<String, dynamic> json) {
    return FormationResult(
      explanation: json['explanation'],
      formation: json['formation'],
      position: json['position'],
      score: json['score'].toDouble(),
      style: json['style'],
    );
  }
}
