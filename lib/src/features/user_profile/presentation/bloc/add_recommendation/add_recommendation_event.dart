abstract class AddRecommendationEvent {}

class AddNewRecommendationEvent extends AddRecommendationEvent {
  final String message;
  final String? itemId;
  final String? restaurantId;
  final bool isItem;

  AddNewRecommendationEvent(
      {required this.isItem,
      this.itemId,
      this.restaurantId,
      required this.message});
}

class ResetAddRecommendation extends AddRecommendationEvent {}
