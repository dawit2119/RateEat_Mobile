class Rank {
  int rank;
  String id;
  String userId;
  int allTimeTotal;
  int currentTotal;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Rank({
    required this.rank,
    required this.id,
    required this.userId,
    required this.allTimeTotal,
    required this.currentTotal,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        rank: json["rank"],
        id: json["id"],
        userId: json["user_id"],
        allTimeTotal: json["all_time_total"],
        currentTotal: json["current_total"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: User.fromJson(json["user"]),
      );
}

class User {
  String id;
  String firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? image;

  User({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        image: json['image'],
      );
}
