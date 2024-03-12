import 'dart:io';

import 'package:equatable/equatable.dart';

class FoodReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitFoodReview extends FoodReviewEvent {
  final String foodId;
  final String reviewMessage;
  final double rating;
  final List<File> reviewMedia;

  SubmitFoodReview(
      {required this.foodId,
      required this.reviewMessage,
      required this.rating,
      required this.reviewMedia});

  @override
  List<Object> get props => [foodId, reviewMessage, rating, reviewMedia];
}
