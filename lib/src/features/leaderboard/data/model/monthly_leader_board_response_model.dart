class MonthlyLeaderBoardResponse {
  final User user;
  final int totalPoints;

  MonthlyLeaderBoardResponse({
    required this.user,
    required this.totalPoints,
  });
  factory MonthlyLeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyLeaderBoardResponse(
      user: User.fromJson(json['user']),
      totalPoints: json['total_points'],
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String? gender;
  final int streak;
  final String phoneNumber;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    this.gender,
    required this.streak,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      image: json['image'] ?? "",
      gender: json['gender'] ?? "",
      streak: json['streak'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
    );
  }
}
