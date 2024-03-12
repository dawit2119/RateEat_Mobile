import 'dart:convert';

import 'package:rateeat_mobile/src/features/vote_on_review/domain/entities/vote_on_review.dart';

import 'review_model.dart';

class VoteResponseModel extends VoteResponse {
  const VoteResponseModel({super.message, super.review});

  factory VoteResponseModel.fromMap(Map<String, dynamic> data) {
    return VoteResponseModel(
      message: data['message'] as String?,
      review: data['review'] == null
          ? null
          : ReviewOnVoteModel.fromMap(data['review'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'review': (review as ReviewOnVoteModel).toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VoteResponseModel].
  factory VoteResponseModel.fromJson(String data) {
    return VoteResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VoteResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());

  VoteResponseModel copyWith({
    String? message,
    ReviewOnVoteModel? review,
  }) {
    return VoteResponseModel(
      message: message ?? this.message,
      review: review ?? this.review,
    );
  }

  @override
  List<Object?> get props => [message, review];
}
