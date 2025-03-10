class TeamStanding {
  final int rank;
  final String team;
  final int wins;
  final int draws;
  final int losses;
  final int gf;
  final int ga;
  final int gd;
  final int points;

  TeamStanding({
    required this.rank,
    required this.team,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.gf,
    required this.ga,
    required this.gd,
    required this.points,
  });

  factory TeamStanding.fromJson(Map<String, dynamic> json, int index) {
    return TeamStanding(
      rank: json["Rank"][index],
      team: json["Teams"][index],
      wins: json["W"][index],
      draws: json["D"][index],
      losses: json["L"][index],
      gf: json["GF"][index],
      ga: json["GA"][index],
      gd: json["GD"][index],
      points: json["Pts"][index],
    );
  }
}
