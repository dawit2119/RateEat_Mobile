class ReviewerProfileResponse {
  String id;
  String firstName;
  String lastName;
  String image;
  final int? verified;
  final int? numberOfReviews;
  ReviewerProfileResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    this.verified,
    this.numberOfReviews,
  });
}
