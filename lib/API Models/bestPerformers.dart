class PlayerStats {
  final String assisterImage;
  final String assistsProvided;
  final String cleanSheets;
  final String cleanSheetsImage;
  final String goalsScored;
  final String mostCSTeam;
  final String mostCleanSheets;
  final String scorerImage;
  final String topAssister;
  final String topAssisterTeam;
  final String topScorer;
  final String topScorerTeam;

  PlayerStats({
    required this.assisterImage,
    required this.assistsProvided,
    required this.cleanSheets,
    required this.cleanSheetsImage,
    required this.goalsScored,
    required this.mostCSTeam,
    required this.mostCleanSheets,
    required this.scorerImage,
    required this.topAssister,
    required this.topAssisterTeam,
    required this.topScorer,
    required this.topScorerTeam,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      assisterImage: json['Assister Image'] as String? ?? '',
      assistsProvided: json['Assists Provided'] as String? ?? '0',
      cleanSheets: json['Clean Sheets'] as String? ?? '0',
      cleanSheetsImage: json['Clean Sheets Image'] as String? ?? '',
      goalsScored: json['Goals Scored'] as String? ?? '0',
      mostCSTeam: json['Most CS Team'] as String? ?? '',
      mostCleanSheets: json['Most Clean Sheets'] as String? ?? '',
      scorerImage: json['Scorer Image'] as String? ?? '',
      topAssister: json['Top Assister'] as String? ?? '',
      topAssisterTeam: json['Top Assister Team'] as String? ?? '',
      topScorer: json['Top Scorer'] as String? ?? '',
      topScorerTeam: json['Top Scorer Team'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Assister Image': assisterImage,
      'Assists Provided': assistsProvided,
      'Clean Sheets': cleanSheets,
      'Clean Sheets Image': cleanSheetsImage,
      'Goals Scored': goalsScored,
      'Most CS Team': mostCSTeam,
      'Most Clean Sheets': mostCleanSheets,
      'Scorer Image': scorerImage,
      'Top Assister': topAssister,
      'Top Assister Team': topAssisterTeam,
      'Top Scorer': topScorer,
      'Top Scorer Team': topScorerTeam,
    };
  }
}
