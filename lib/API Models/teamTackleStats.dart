import 'dart:convert';

class TeamTackleStats {
  final String teamName;
  final double tacklesPer90;
  final double tacklesWonPer90;

  TeamTackleStats({
    required this.teamName,
    required this.tacklesPer90,
    required this.tacklesWonPer90,
  });

  // Factory method to create a TeamTackleStats object from JSON
  factory TeamTackleStats.fromJson(String teamName, Map<String, dynamic> json) {
    return TeamTackleStats(
      teamName: teamName,
      tacklesPer90: (json['Tackles Per 90'] as num).toDouble(),
      tacklesWonPer90: (json['Tackles Won Per 90'] as num).toDouble(),
    );
  }

  // Convert TeamTackleStats object to JSON
  Map<String, dynamic> toJson() {
    return {
      'teamName': teamName,
      'Tackles Per 90': tacklesPer90,
      'Tackles Won Per 90': tacklesWonPer90,
    };
  }

  @override
  String toString() {
    return 'TeamTackleStats(teamName: $teamName, Tackles Per 90: $tacklesPer90, Tackles Won Per 90: $tacklesWonPer90)';
  }
}

// Function to parse API response into a list of TeamTackleStats objects
List<TeamTackleStats> parseTeamTackleStats(String responseBody) {
  final Map<String, dynamic> jsonData = json.decode(responseBody);
  return jsonData.entries
      .map((entry) => TeamTackleStats.fromJson(entry.key, entry.value))
      .toList();
}
