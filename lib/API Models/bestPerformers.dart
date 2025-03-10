class BestPerformers {
  final PlayerStat topScorer;
  final PlayerStat topAssister;
  final PlayerStat cleanSheets;

  BestPerformers({
    required this.topScorer,
    required this.topAssister,
    required this.cleanSheets,
  });

  factory BestPerformers.fromJson(Map<String, dynamic> json) {
    // Extract the "data" key first
    final Map<String, dynamic>? data = json['data'];

    if (data == null) {
      throw Exception("Invalid API response: 'data' key is missing");
    }

    return BestPerformers(
      topScorer: PlayerStat.fromJson(data['Top Scorer']),
      topAssister: PlayerStat.fromJson(data['Top Assister']),
      cleanSheets: PlayerStat.fromJson(data['Clean Sheets']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'Top Scorer': topScorer.toJson(),
        'Top Assister': topAssister.toJson(),
        'Clean Sheets': cleanSheets.toJson(),
      }
    };
  }
}

class PlayerStat {
  final String name;
  final String stat;
  final String imageUrl;
  final String team;

  PlayerStat({
    required this.name,
    required this.stat,
    required this.imageUrl,
    required this.team,
  });

  factory PlayerStat.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw Exception("Invalid PlayerStat JSON: $json");
    }

    String playerName = json.keys.first; // Extract player name dynamically
    return PlayerStat(
      name: playerName,
      stat: json[playerName] ?? "0",
      imageUrl: json['image'] ?? "",
      team: json['team'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      name: stat,
      'image': imageUrl,
      'team': team,
    };
  }
}
