import 'dart:convert';

import '../../../domain/entity/user_review.dart';

class ReviewMediaModel extends ReviewMedia {
  const ReviewMediaModel({super.id, super.url});

  factory ReviewMediaModel.fromMap(Map<String, dynamic> data) {
    return ReviewMediaModel(
      id: data['id'] as String?,
      url: data['url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'url': url,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ReviewMediaModel].
  factory ReviewMediaModel.fromJson(String data) {
    return ReviewMediaModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ReviewMediaModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ReviewMediaModel copyWith({
    String? id,
    String? url,
  }) {
    return ReviewMediaModel(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [id, url];
}
