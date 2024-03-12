import 'dart:io';

import 'package:equatable/equatable.dart';

class RestaurantReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitRestaurantReview extends RestaurantReviewEvent {
  final String restaurantId;
  final String reviewMessage;
  final double rating;
  final List<File> reviewMedia;

  SubmitRestaurantReview(
      {required this.restaurantId,
      required this.reviewMessage,
      required this.rating,
      required this.reviewMedia});

  @override
  List<Object> get props => [restaurantId, reviewMessage, rating, reviewMedia];
}
