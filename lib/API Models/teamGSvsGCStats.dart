import 'dart:convert';

class TeamGoalScoredConcededStats {
  final String teamName;
  final double goalsPer90;
  final double goalsConcededPer90;

  TeamGoalScoredConcededStats({
    required this.teamName,
    required this.goalsPer90,
    required this.goalsConcededPer90,
  });

  // Factory method to create a TeamStats object from JSON
  factory TeamGoalScoredConcededStats.fromJson(
      String teamName, Map<String, dynamic> json) {
    return TeamGoalScoredConcededStats(
      teamName: teamName,
      goalsPer90: (json['Goals Per Game'] as num).toDouble(),
      goalsConcededPer90: (json['Goals Conceded Per Game'] as num).toDouble(),
    );
  }

  // Convert TeamStats object to JSON
  Map<String, dynamic> toJson() {
    return {
      'teamName': teamName,
      'Goals Per Game': goalsPer90,
      'Goals Conceded Per Game': goalsConcededPer90,
    };
  }

  @override
  String toString() {
    return 'TeamStats(teamName: $teamName, Goals Per 90: $goalsPer90, Goals Conceded Per 90: $goalsConcededPer90)';
  }
}

// Function to parse API response into a list of TeamStats objects
List<TeamGoalScoredConcededStats> parseTeamStats(String responseBody) {
  final Map<String, dynamic> jsonData = json.decode(responseBody);
  return jsonData.entries
      .map((entry) =>
          TeamGoalScoredConcededStats.fromJson(entry.key, entry.value))
      .toList();
}
