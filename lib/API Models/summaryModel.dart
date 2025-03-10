class PlayerComparisonReport {
  final String report;

  PlayerComparisonReport({required this.report});

  // Factory constructor to create an instance from JSON
  factory PlayerComparisonReport.fromJson(Map<String, dynamic> json) {
    return PlayerComparisonReport(
      report: json['report'] ?? '', // Fallback to an empty string if null
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'report': report,
    };
  }
}
