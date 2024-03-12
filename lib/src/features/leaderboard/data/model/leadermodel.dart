class LeaderBoardModel {
  String id;
  String userId;
  int allTimeTotal;
  int currentTotal;
  String createdAt;
  String updatedAt;
  User user;

  LeaderBoardModel({
    required this.id,
    required this.userId,
    required this.allTimeTotal,
    required this.currentTotal,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    return LeaderBoardModel(
      id: json['id'] ?? "",
      userId: json['user_id'] ?? "",
      allTimeTotal: json['all_time_total'] ?? "",
      currentTotal: json['current_total'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String? image;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      image: json['image'] ?? "",
    );
  }
}
