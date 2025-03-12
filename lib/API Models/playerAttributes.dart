import 'dart:convert';

abstract class PlayerAttributes {
  Map<String, double> toMap();
}

class CBAttributes extends PlayerAttributes {
  final double defensiveActions;
  final double aerialDuels;
  final double passingBuildUp;
  final double defensiveAwareness;
  final double discipline;

  CBAttributes({
    required this.defensiveActions,
    required this.aerialDuels,
    required this.passingBuildUp,
    required this.defensiveAwareness,
    required this.discipline,
  });

  factory CBAttributes.fromJson(Map<String, dynamic> json) {
    return CBAttributes(
      defensiveActions: json["Defensive Actions"] ?? 0.0,
      aerialDuels: json["Aerial Duels"] ?? 0.0,
      passingBuildUp: json["Passing and Build-up"] ?? 0.0,
      defensiveAwareness: json["Defensive Awareness"] ?? 0.0,
      discipline: json["Discipline"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Actions": defensiveActions,
        "Aerial Duels": aerialDuels,
        "Passing and Build-up": passingBuildUp,
        "Defensive Awareness": defensiveAwareness,
        "Discipline": discipline,
      };
}

// Repeat the structure for other positions

class LBAttributes extends PlayerAttributes {
  final double defensiveDuties;
  final double dribbling;
  final double finalThirdPlay;
  final double offensiveContributions;
  final double possessionPlay;

  LBAttributes({
    required this.defensiveDuties,
    required this.dribbling,
    required this.finalThirdPlay,
    required this.offensiveContributions,
    required this.possessionPlay,
  });

  factory LBAttributes.fromJson(Map<String, dynamic> json) {
    return LBAttributes(
      defensiveDuties: json["Defensive Duties"] ?? 0.0,
      dribbling: json["Dribbling"] ?? 0.0,
      finalThirdPlay: json["Final Third Play"] ?? 0.0,
      offensiveContributions: json["Offensive Contributions"] ?? 0.0,
      possessionPlay: json["Possession Play"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Duties": defensiveDuties,
        "Dribbling": dribbling,
        "Final Third Play": finalThirdPlay,
        "Offensive Contributions": offensiveContributions,
        "Possession Play": possessionPlay,
      };
}

class RBAttributes extends PlayerAttributes {
  final double defensiveDuties;
  final double dribbling;
  final double finalThirdPlay;
  final double offensiveContributions;
  final double possessionPlay;

  RBAttributes({
    required this.defensiveDuties,
    required this.dribbling,
    required this.finalThirdPlay,
    required this.offensiveContributions,
    required this.possessionPlay,
  });

  factory RBAttributes.fromJson(Map<String, dynamic> json) {
    return RBAttributes(
      defensiveDuties: json["Defensive Duties"] ?? 0.0,
      dribbling: json["Dribbling"] ?? 0.0,
      finalThirdPlay: json["Final Third Play"] ?? 0.0,
      offensiveContributions: json["Offensive Contributions"] ?? 0.0,
      possessionPlay: json["Possession Play"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Duties": defensiveDuties,
        "Dribbling": dribbling,
        "Final Third Play": finalThirdPlay,
        "Offensive Contributions": offensiveContributions,
        "Possession Play": possessionPlay,
      };
}

// Repeat the structure for other positions

class CDMAttributes extends PlayerAttributes {
  final double defensiveContribution;
  final double passingAbility;
  final double buildUpPlay;
  final double ballRecovery;
  final double lineBreakingPasses;

  CDMAttributes({
    required this.defensiveContribution,
    required this.passingAbility,
    required this.buildUpPlay,
    required this.ballRecovery,
    required this.lineBreakingPasses,
  });

  factory CDMAttributes.fromJson(Map<String, dynamic> json) {
    return CDMAttributes(
      defensiveContribution: json["Defensive Contribution"] ?? 0.0,
      passingAbility: json["Passing Ability"] ?? 0.0,
      buildUpPlay: json["Build-Up Play"] ?? 0.0,
      ballRecovery: json["Ball Recovery"] ?? 0.0,
      lineBreakingPasses: json["Line Breaking Passes"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Contribution": defensiveContribution,
        "Passing Ability": passingAbility,
        "Build-Up Play": buildUpPlay,
        "Ball Recovery": ballRecovery,
        "Line Breaking Passes": lineBreakingPasses,
      };
}

class CMAttributes extends PlayerAttributes {
  final double passing;
  final double ballCarrying;
  final double defensiveWork;
  final double chanceCreation;
  final double possessionRetention;

  CMAttributes({
    required this.passing,
    required this.ballCarrying,
    required this.defensiveWork,
    required this.chanceCreation,
    required this.possessionRetention,
  });

  factory CMAttributes.fromJson(Map<String, dynamic> json) {
    return CMAttributes(
      passing: json["Passing"] ?? 0.0,
      ballCarrying: json["Ball Carrying"] ?? 0.0,
      defensiveWork: json["Defensive Work"] ?? 0.0,
      chanceCreation: json["Chance Creation"] ?? 0.0,
      possessionRetention: json["Possession Retention"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Passing": passing,
        "Ball Carrying": ballCarrying,
        "Defensive Work": defensiveWork,
        "Chance Creation": chanceCreation,
        "Possession Retention": possessionRetention,
      };
}

class CAMAttributes extends PlayerAttributes {
  final double playmaking;
  final double ballProgression;
  final double finalThirdImpact;
  final double goalThreat;
  final double finalBallEfficiency;

  CAMAttributes({
    required this.playmaking,
    required this.ballProgression,
    required this.finalThirdImpact,
    required this.goalThreat,
    required this.finalBallEfficiency,
  });

  factory CAMAttributes.fromJson(Map<String, dynamic> json) {
    return CAMAttributes(
      playmaking: json["Playmaking"] ?? 0.0,
      ballProgression: json["Ball Progression"] ?? 0.0,
      finalThirdImpact: json["Final Third Impact"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      finalBallEfficiency: json["Final Ball Efficiency"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Playmaking": playmaking,
        "Ball Progression": ballProgression,
        "Final Third Impact": finalThirdImpact,
        "Goal Threat": goalThreat,
        "Final Ball Efficiency": finalBallEfficiency,
      };
}

class LWAttributes extends PlayerAttributes {
  final double dribbling;
  final double crosses;
  final double goalThreat;
  final double finalThirdImpact;
  final double ballCarrying;

  LWAttributes({
    required this.dribbling,
    required this.crosses,
    required this.finalThirdImpact,
    required this.goalThreat,
    required this.ballCarrying,
  });

  factory LWAttributes.fromJson(Map<String, dynamic> json) {
    return LWAttributes(
      dribbling: json["Dribbling"] ?? 0.0,
      crosses: json["Crosses"] ?? 0.0,
      finalThirdImpact: json["Final Third Impact"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      ballCarrying: json["Ball Carrying"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Dribbling": dribbling,
        "Ball Carrying": ballCarrying,
        "Final Third Impact": finalThirdImpact,
        "Goal Threat": goalThreat,
        "Crosses": crosses,
      };
}

class RWAttributes extends PlayerAttributes {
  final double dribbling;
  final double crosses;
  final double goalThreat;
  final double finalThirdImpact;
  final double ballCarrying;

  RWAttributes({
    required this.dribbling,
    required this.crosses,
    required this.finalThirdImpact,
    required this.goalThreat,
    required this.ballCarrying,
  });

  factory RWAttributes.fromJson(Map<String, dynamic> json) {
    return RWAttributes(
      dribbling: json["Dribbling"] ?? 0.0,
      crosses: json["Crosses"] ?? 0.0,
      finalThirdImpact: json["Final Third Impact"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      ballCarrying: json["Ball Carrying"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Dribbling": dribbling,
        "Ball Carrying": ballCarrying,
        "Final Third Impact": finalThirdImpact,
        "Goal Threat": goalThreat,
        "Crosses": crosses,
      };
}

class CFAttributes extends PlayerAttributes {
  final double chanceConversion;
  final double linkUpPlay;
  final double goalThreat;
  final double shootingAccuracy;
  final double penaltyBoxPresence;

  CFAttributes({
    required this.chanceConversion,
    required this.linkUpPlay,
    required this.shootingAccuracy,
    required this.goalThreat,
    required this.penaltyBoxPresence,
  });

  factory CFAttributes.fromJson(Map<String, dynamic> json) {
    return CFAttributes(
      chanceConversion: json["Chance Conversion"] ?? 0.0,
      linkUpPlay: json["Link-Up Play"] ?? 0.0,
      shootingAccuracy: json["Shooting Accuracy"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      penaltyBoxPresence: json["Penalty Box Presence"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Chance Conversion": chanceConversion,
        "Link-Up Play": linkUpPlay,
        "Shooting Accuracy": shootingAccuracy,
        "Goal Threat": goalThreat,
        "Penalty Box Presence": penaltyBoxPresence,
      };
}

class GKAttributes extends PlayerAttributes {
  final double shotStopping;
  final double expectedGoalsPrevented;
  final double crossAndAerialControl;
  final double sweeperKeeperActivity;
  final double passing;

  GKAttributes({
    required this.shotStopping,
    required this.expectedGoalsPrevented,
    required this.crossAndAerialControl,
    required this.sweeperKeeperActivity,
    required this.passing,
  });

  factory GKAttributes.fromJson(Map<String, dynamic> json) {
    return GKAttributes(
      shotStopping: json["Shot Stopping"] ?? 0.0,
      expectedGoalsPrevented: json["Expected Goals Prevented"] ?? 0.0,
      crossAndAerialControl: json["Cross and Aerial Control"] ?? 0.0,
      sweeperKeeperActivity: json["Sweeper Keeper Activity"] ?? 0.0,
      passing: json["Passing"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Shot Stopping": shotStopping,
        "Expected Goals Prevented": expectedGoalsPrevented,
        "Cross and Aerial Control": crossAndAerialControl,
        "Sweeper Keeper Activity": sweeperKeeperActivity,
        "Passing": passing,
      };
}
