class PlayerDashboardModel {
  final Map<String, double> stats;

  PlayerDashboardModel({required this.stats});

  factory PlayerDashboardModel.fromJson(Map<String, dynamic> json) {
    final parsedStats = <String, double>{};

    json.forEach((key, value) {
      if (value is num) {
        parsedStats[key] = value.toDouble();
      }
    });

    return PlayerDashboardModel(stats: parsedStats);
  }

  Map<String, dynamic> toJson() {
    return stats.map((key, value) => MapEntry(key, value));
  }

  double getStat(String statKey) {
    return stats[statKey] ?? 0.0;
  }
}
