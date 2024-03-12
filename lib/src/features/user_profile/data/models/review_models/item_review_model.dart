import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

class ItemReviewModel {
  String id;
  double? rating;
  String? comment;
  int? upVote;
  int? downVote;
  bool? visibility;
  DateTime? createdAt;
  DateTime? updatedAt;
  ReviewerProfileModel? user;
  List<dynamic>? images;
  List<dynamic>? videos;
  int? voted;

  ItemReviewModel({
    required this.id,
    this.rating,
    this.comment,
    this.upVote,
    this.downVote,
    this.visibility,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.images,
    this.videos,
    this.voted,
  });

  factory ItemReviewModel.fromJson(Map<String, dynamic> json) =>
      ItemReviewModel(
        id: json["id"] ?? "",
        rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
        comment: json["comment"] ?? "",
        upVote: json["upVote"] ?? 0,
        downVote: json["downVote"] ?? 0,
        visibility: json['visibility'] as bool? ?? false,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        user: json["user"] != null
            ? ReviewerProfileModel.fromJson(json["user"])
            : ReviewerProfileModel(
                id: json['user_id'],
                firstName: dpLocator<AuthenticationLocalSource>()
                    .getUserCredential()!
                    .firstName!,
                lastName: dpLocator<AuthenticationLocalSource>()
                    .getUserCredential()!
                    .lastName!,
                image: json['image'] != null && json['image']['url'] != null
                    ? json['image']['url']
                    : '',
              ),
        images: (json['images'] != null && json['images'].isNotEmpty)
            ? json['images'].map((review) => review).toList()
            : [],
        videos: (json['videos'] != null && json['videos'].isNotEmpty)
            ? json['videos'].map((review) => review["url"]).toList()
            : [],
        voted: json['voted'] != null ? json['voted'] as int? : 0,
        // You might need to change this based on the actual structure of the "videos" property.
      );
}

class ReviewerProfileModel {
  String id;
  String firstName;
  String lastName;
  String image;

  ReviewerProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  factory ReviewerProfileModel.fromJson(Map<String, dynamic> json) =>
      ReviewerProfileModel(
        id: json["id"],
        firstName: json["firstName"] ?? '',
        lastName: json["lastName"] ?? '',
        image: json['image'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
      };
}
