class TopScorer {
  final String name;
  final String team;
  final int goals;
  final int matches;

  TopScorer({
    required this.name,
    required this.team,
    required this.goals,
    required this.matches,
  });

  factory TopScorer.fromJson(Map<String, dynamic> json) {
    return TopScorer(
      name: json['player']['name'] ?? 'Unknown',
      team: json['team']['name'] ?? 'Unknown',
      goals: json['goals'] ?? 0,
      matches: json['playedMatches'] ?? 0,
    );
  }

  static List<TopScorer> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => TopScorer.fromJson(e)).toList();
  }
}
