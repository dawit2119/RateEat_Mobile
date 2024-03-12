import 'package:hive/hive.dart';

part 'popular_item_reviewer_profile_response.g.dart';

@HiveType(typeId: 40)
class PopularItemReviewerProfileResponse {
  @HiveField(0)
  String id;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String image;
  @HiveField(4)
  int? verified;
  @HiveField(5)
  int? numberOfReviews;

  PopularItemReviewerProfileResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    this.verified,
    this.numberOfReviews,
  });
}
