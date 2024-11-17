class PlayerClass {
  final List<String> per90;
  final List<double> percentile;
  final Map<String, String> personalInfo;
  final List<String> statistic;

  PlayerClass({
    required this.per90,
    required this.percentile,
    required this.personalInfo,
    required this.statistic,
  });

  factory PlayerClass.fromJson(Map<String, dynamic> json) {
    return PlayerClass(
      per90: List<String>.from(json['Per 90'] ?? []),
      percentile:
          List<double>.from(json['Percentile']?.map((e) => e.toDouble()) ?? []),
      personalInfo: Map<String, String>.from(json['Personal Info'] ?? {}),
      statistic: List<String>.from(json['Statistic'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Per 90': per90,
      'Percentile': percentile,
      'Personal Info': personalInfo,
      'Statistic': statistic,
    };
  }
}
