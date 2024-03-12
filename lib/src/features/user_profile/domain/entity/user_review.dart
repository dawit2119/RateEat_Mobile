import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'user_review.g.dart';

@HiveType(typeId: 16)
class UserReview extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final double? rating;
  @HiveField(3)
  final String? comment;
  @HiveField(4)
  final int? upVote;
  @HiveField(5)
  final int? downVote;
  @HiveField(6)
  final bool? visibility;
  @HiveField(7)
  final DateTime? createdAt;
  @HiveField(8)
  final DateTime? updatedAt;
  @HiveField(9)
  final ReviewSubject? reviewSubject;
  @HiveField(10)
  final List<ReviewMedia> images;
  final List<ReviewMedia>? videos;
  @HiveField(12)
  final int? voted;

  const UserReview({
    this.id,
    this.userId,
    this.rating,
    this.comment,
    this.upVote,
    this.downVote,
    this.visibility,
    this.createdAt,
    this.updatedAt,
    this.reviewSubject,
    this.images = const [],
    this.videos,
    this.voted,
  });

  @override
  List<Object?> get props => [];
}

@HiveType(typeId: 28)
class ReviewSubject extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final bool? isItem;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final List<dynamic>? itemImages;
  @HiveField(5)
  final List<dynamic>? itemVideos;

  const ReviewSubject({
    this.id,
    this.name,
    this.isItem,
    this.imageUrl,
    this.itemImages,
    this.itemVideos,
  });

  @override
  List<Object?> get props => [];
}

@HiveType(typeId: 29)
class ReviewMedia extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? url;

  const ReviewMedia({this.id, this.url});

  @override
  List<Object?> get props => [];
}
