class GarminUser {
  String apiId;
  String userId;
  String accessToken;
  bool isConnected;
  bool activities;
  bool womenHealth;
  bool dailySummary;
  bool trainings;
  bool courses;

  GarminUser({
    this.apiId = '',
    this.userId = '',
    this.accessToken = '',
    this.isConnected = false,
    this.activities = false,
    this.womenHealth = false,
    this.dailySummary = false,
    this.trainings = false,
    this.courses = false,
  });

  factory GarminUser.fromJson(Map<String, dynamic> json) {
    return GarminUser(
      apiId: json['api_id'],
      userId: json['user_id'],
      accessToken: json['access_token'],
      isConnected: json['is_connected'],
      activities: json['activities'],
      womenHealth: json['women_health'],
      dailySummary: json['daily_summary'],
      trainings: json['trainings'],
      courses: json['courses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'api_id': apiId,
      'user_id': userId,
      'access_token': accessToken,
      'is_connected': isConnected,
      'activities': activities,
      'women_health': womenHealth,
      'daily_summary': dailySummary,
      'trainings': trainings,
      'courses': courses,
    };
  }
}
