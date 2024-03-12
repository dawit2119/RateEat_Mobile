import 'dart:convert';

import '../../domain/entities/vote_on_review.dart';

class ReviewOnVoteModel extends ReviewOnVote {
  const ReviewOnVoteModel({
    super.id,
    super.itemId,
    super.userId,
    super.rating,
    super.comment,
    super.upVote,
    super.downVote,
    super.visibility,
    super.createdAt,
    super.updatedAt,
    super.voted,
  });

  factory ReviewOnVoteModel.fromMap(Map<String, dynamic> data) =>
      ReviewOnVoteModel(
        id: data['id'] as String?,
        itemId: data['item_id'] as String?,
        userId: data['user_id'] as String?,
        rating: double.parse(data['rating'].toString()),
        comment: data['comment'] as String?,
        upVote: data['up_vote'] as int?,
        downVote: data['down_vote'] as int?,
        visibility: data['visibility'] as bool?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        voted: data['voted'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'item_id': itemId,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
        'up_vote': upVote,
        'down_vote': downVote,
        'visibility': visibility,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'voted': voted,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ReviewOnVoteModel].
  factory ReviewOnVoteModel.fromJson(String data) {
    return ReviewOnVoteModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ReviewOnVoteModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ReviewOnVoteModel copyWith({
    String? id,
    String? itemId,
    String? userId,
    double? rating,
    String? comment,
    int? upVote,
    int? downVote,
    bool? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? voted,
  }) {
    return ReviewOnVoteModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      voted: voted ?? this.voted,
    );
  }

  @override
  List<Object?> get props {
    return [
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
}
