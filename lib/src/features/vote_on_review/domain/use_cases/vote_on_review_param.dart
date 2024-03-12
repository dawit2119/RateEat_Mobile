import 'package:equatable/equatable.dart';

class VoteOnReviewParam extends Equatable {
  final String reviewId;
  final String userId;

  const VoteOnReviewParam({
    required this.reviewId,
    required this.userId,
  });

  @override
  List<Object?> get props => [reviewId, userId];
}
