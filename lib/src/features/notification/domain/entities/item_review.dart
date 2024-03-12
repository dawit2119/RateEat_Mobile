import 'package:equatable/equatable.dart';

class TargetReview extends Equatable {
  final String id;
  final String notifiableId;
  final String userId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String? imageUrl;

  const TargetReview({
    required this.id,
    required this.notifiableId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        notifiableId,
        userId,
        rating,
        comment,
        createdAt,
        imageUrl,
      ];
}
