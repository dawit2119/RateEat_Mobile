import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_item_response.dart';

part 'saved_reviews_response.g.dart';

@HiveType(typeId: 30)
class SavedReviewsResponse extends Equatable {
  @HiveField(0)
  final String? draftId;
  @HiveField(1)
  final SavedReviewItemResponse? item;
  @HiveField(2)
  final DateTime? createdAt;
  @HiveField(3)
  final List<DraftFileContent>? images;
  @HiveField(4)
  final List<DraftFileContent>? videos;

  const SavedReviewsResponse({
    this.draftId,
    this.item,
    this.createdAt,
    this.images,
    this.videos,
  });

  @override
  List<Object?> get props => [];
}

@HiveType(typeId: 49)
class DraftFileContent extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? url;
  @HiveField(2)
  final String? itemReviewId;
  @HiveField(3)
  final DateTime? createdAt;

  const DraftFileContent({
    this.id,
    this.url,
    this.itemReviewId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [];
}
