import 'package:equatable/equatable.dart';

class VoteResponse extends Equatable {
  final String? message;
  final ReviewOnVote? review;

  const VoteResponse({this.message, this.review});

  @override
  List<Object?> get props => [message, review];
}

class ReviewOnVote extends Equatable {
  final String? id;
  final String? itemId;
  final String? userId;
  final double? rating;
  final String? comment;
  final int? upVote;
  final int? downVote;
  final bool? visibility;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? voted;

  const ReviewOnVote({
    this.id,
    this.itemId,
    this.userId,
    this.rating,
    this.comment,
    this.upVote,
    this.downVote,
    this.visibility,
    this.createdAt,
    this.updatedAt,
    this.voted,
  });

  @override
  List<Object?> get props => [
        id,
        itemId,
        userId,
        rating,
        comment,
        upVote,
        downVote,
        visibility,
        createdAt,
        updatedAt,
        voted,
      ];
}
