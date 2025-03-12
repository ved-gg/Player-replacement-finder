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
  final double tis;

  CBAttributes({
    required this.defensiveActions,
    required this.aerialDuels,
    required this.passingBuildUp,
    required this.defensiveAwareness,
    required this.discipline,
    required this.tis,
  });

  factory CBAttributes.fromJson(Map<String, dynamic> json) {
    return CBAttributes(
        defensiveActions: json["Defensive Actions"] ?? 0.0,
        aerialDuels: json["Aerial Duels"] ?? 0.0,
        passingBuildUp: json["Passing and Build-up"] ?? 0.0,
        defensiveAwareness: json["Defensive Awareness"] ?? 0.0,
        discipline: json["Discipline"] ?? 0.0,
        tis: json["TIS"] ?? 0.0);
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Actions": defensiveActions,
        "Aerial Duels": aerialDuels,
        "Passing and Build-up": passingBuildUp,
        "Defensive Awareness": defensiveAwareness,
        "Discipline": discipline,
        "TIS": tis,
      };
}

// Repeat the structure for other positions

class LBAttributes extends PlayerAttributes {
  final double defensiveDuties;
  final double dribbling;
  final double finalThirdPlay;
  final double offensiveContributions;
  final double possessionPlay;
  final double tis;

  LBAttributes({
    required this.defensiveDuties,
    required this.dribbling,
    required this.finalThirdPlay,
    required this.offensiveContributions,
    required this.possessionPlay,
    required this.tis,
  });

  factory LBAttributes.fromJson(Map<String, dynamic> json) {
    return LBAttributes(
      defensiveDuties: json["Defensive Duties"] ?? 0.0,
      dribbling: json["Dribbling"] ?? 0.0,
      finalThirdPlay: json["Final Third Play"] ?? 0.0,
      offensiveContributions: json["Offensive Contributions"] ?? 0.0,
      possessionPlay: json["Possession Play"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Duties": defensiveDuties,
        "Dribbling": dribbling,
        "Final Third Play": finalThirdPlay,
        "Offensive Contributions": offensiveContributions,
        "Possession Play": possessionPlay,
        "TIS": tis,
      };
}

class RBAttributes extends PlayerAttributes {
  final double defensiveDuties;
  final double dribbling;
  final double finalThirdPlay;
  final double offensiveContributions;
  final double possessionPlay;
  final double tis;

  RBAttributes({
    required this.defensiveDuties,
    required this.dribbling,
    required this.finalThirdPlay,
    required this.offensiveContributions,
    required this.possessionPlay,
    required this.tis,
  });

  factory RBAttributes.fromJson(Map<String, dynamic> json) {
    return RBAttributes(
      defensiveDuties: json["Defensive Duties"] ?? 0.0,
      dribbling: json["Dribbling"] ?? 0.0,
      finalThirdPlay: json["Final Third Play"] ?? 0.0,
      offensiveContributions: json["Offensive Contributions"] ?? 0.0,
      possessionPlay: json["Possession Play"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Duties": defensiveDuties,
        "Dribbling": dribbling,
        "Final Third Play": finalThirdPlay,
        "Offensive Contributions": offensiveContributions,
        "Possession Play": possessionPlay,
        "TIS": tis,
      };
}

// Repeat the structure for other positions

class CDMAttributes extends PlayerAttributes {
  final double defensiveContribution;
  final double passingAbility;
  final double buildUpPlay;
  final double ballRecovery;
  final double lineBreakingPasses;
  final double tis;

  CDMAttributes({
    required this.defensiveContribution,
    required this.passingAbility,
    required this.buildUpPlay,
    required this.ballRecovery,
    required this.lineBreakingPasses,
    required this.tis,
  });

  factory CDMAttributes.fromJson(Map<String, dynamic> json) {
    return CDMAttributes(
      defensiveContribution: json["Defensive Contribution"] ?? 0.0,
      passingAbility: json["Passing Ability"] ?? 0.0,
      buildUpPlay: json["Build-Up Play"] ?? 0.0,
      ballRecovery: json["Ball Recovery"] ?? 0.0,
      lineBreakingPasses: json["Line Breaking Passes"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Defensive Contribution": defensiveContribution,
        "Passing Ability": passingAbility,
        "Build-Up Play": buildUpPlay,
        "Ball Recovery": ballRecovery,
        "Line Breaking Passes": lineBreakingPasses,
        "TIS": tis,
      };
}

class CMAttributes extends PlayerAttributes {
  final double passing;
  final double ballCarrying;
  final double defensiveWork;
  final double chanceCreation;
  final double possessionRetention;
  final double tis;

  CMAttributes({
    required this.passing,
    required this.ballCarrying,
    required this.defensiveWork,
    required this.chanceCreation,
    required this.possessionRetention,
    required this.tis,
  });

  factory CMAttributes.fromJson(Map<String, dynamic> json) {
    return CMAttributes(
      passing: json["Passing"] ?? 0.0,
      ballCarrying: json["Ball Carrying"] ?? 0.0,
      defensiveWork: json["Defensive Work"] ?? 0.0,
      chanceCreation: json["Chance Creation"] ?? 0.0,
      possessionRetention: json["Possession Retention"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Passing": passing,
        "Ball Carrying": ballCarrying,
        "Defensive Work": defensiveWork,
        "Chance Creation": chanceCreation,
        "Possession Retention": possessionRetention,
        "TIS": tis,
      };
}

class CAMAttributes extends PlayerAttributes {
  final double playmaking;
  final double ballProgression;
  final double finalThirdImpact;
  final double goalThreat;
  final double finalBallEfficiency;
  final double tis;

  CAMAttributes({
    required this.playmaking,
    required this.ballProgression,
    required this.finalThirdImpact,
    required this.goalThreat,
    required this.finalBallEfficiency,
    required this.tis,
  });

  factory CAMAttributes.fromJson(Map<String, dynamic> json) {
    return CAMAttributes(
      playmaking: json["Playmaking"] ?? 0.0,
      ballProgression: json["Ball Progression"] ?? 0.0,
      finalThirdImpact: json["Final Third Impact"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      finalBallEfficiency: json["Final Ball Efficiency"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Playmaking": playmaking,
        "Ball Progression": ballProgression,
        "Final Third Impact": finalThirdImpact,
        "Goal Threat": goalThreat,
        "Final Ball Efficiency": finalBallEfficiency,
        "TIS": tis,
      };
}

class LWAttributes extends PlayerAttributes {
  final double dribbling;
  final double crosses;
  final double goalThreat;
  final double finalThirdImpact;
  final double ballCarrying;
  final double tis;

  LWAttributes({
    required this.dribbling,
    required this.crosses,
    required this.finalThirdImpact,
    required this.goalThreat,
    required this.ballCarrying,
    required this.tis,
  });

  factory LWAttributes.fromJson(Map<String, dynamic> json) {
    return LWAttributes(
      dribbling: json["Dribbling"] ?? 0.0,
      crosses: json["Crosses"] ?? 0.0,
      finalThirdImpact: json["Final Third Impact"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      ballCarrying: json["Ball Carrying"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Dribbling": dribbling,
        "Ball Carrying": ballCarrying,
        "Final Third Impact": finalThirdImpact,
        "Goal Threat": goalThreat,
        "Crosses": crosses,
        "TIS": tis,
      };
}

class RWAttributes extends PlayerAttributes {
  final double dribbling;
  final double crosses;
  final double goalThreat;
  final double finalThirdImpact;
  final double ballCarrying;
  final double tis;

  RWAttributes({
    required this.dribbling,
    required this.crosses,
    required this.finalThirdImpact,
    required this.goalThreat,
    required this.ballCarrying,
    required this.tis,
  });

  factory RWAttributes.fromJson(Map<String, dynamic> json) {
    return RWAttributes(
      dribbling: json["Dribbling"] ?? 0.0,
      crosses: json["Crosses"] ?? 0.0,
      finalThirdImpact: json["Final Third Impact"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      ballCarrying: json["Ball Carrying"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Dribbling": dribbling,
        "Ball Carrying": ballCarrying,
        "Final Third Impact": finalThirdImpact,
        "Goal Threat": goalThreat,
        "Crosses": crosses,
        "TIS": tis,
      };
}

class CFAttributes extends PlayerAttributes {
  final double chanceConversion;
  final double linkUpPlay;
  final double goalThreat;
  final double shootingAccuracy;
  final double penaltyBoxPresence;
  final double tis;

  CFAttributes({
    required this.chanceConversion,
    required this.linkUpPlay,
    required this.shootingAccuracy,
    required this.goalThreat,
    required this.penaltyBoxPresence,
    required this.tis,
  });

  factory CFAttributes.fromJson(Map<String, dynamic> json) {
    return CFAttributes(
      chanceConversion: json["Chance Conversion"] ?? 0.0,
      linkUpPlay: json["Link-Up Play"] ?? 0.0,
      shootingAccuracy: json["Shooting Accuracy"] ?? 0.0,
      goalThreat: json["Goal Threat"] ?? 0.0,
      penaltyBoxPresence: json["Penalty Box Presence"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Chance Conversion": chanceConversion,
        "Link-Up Play": linkUpPlay,
        "Shooting Accuracy": shootingAccuracy,
        "Goal Threat": goalThreat,
        "Penalty Box Presence": penaltyBoxPresence,
        "TIS": tis,
      };
}

class GKAttributes extends PlayerAttributes {
  final double shotStopping;
  final double expectedGoalsPrevented;
  final double crossAndAerialControl;
  final double sweeperKeeperActivity;
  final double passing;
  final double tis;

  GKAttributes({
    required this.shotStopping,
    required this.expectedGoalsPrevented,
    required this.crossAndAerialControl,
    required this.sweeperKeeperActivity,
    required this.passing,
    required this.tis,
  });

  factory GKAttributes.fromJson(Map<String, dynamic> json) {
    return GKAttributes(
      shotStopping: json["Shot Stopping"] ?? 0.0,
      expectedGoalsPrevented: json["Expected Goals Prevented"] ?? 0.0,
      crossAndAerialControl: json["Cross and Aerial Control"] ?? 0.0,
      sweeperKeeperActivity: json["Sweeper Keeper Activity"] ?? 0.0,
      passing: json["Passing"] ?? 0.0,
      tis: json["TIS"] ?? 0.0,
    );
  }

  @override
  Map<String, double> toMap() => {
        "Shot Stopping": shotStopping,
        "Expected Goals Prevented": expectedGoalsPrevented,
        "Cross and Aerial Control": crossAndAerialControl,
        "Sweeper Keeper Activity": sweeperKeeperActivity,
        "Passing": passing,
        "TIS": tis,
      };
}
