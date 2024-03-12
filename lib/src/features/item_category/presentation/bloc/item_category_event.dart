import 'package:equatable/equatable.dart';

// * Search food category event
abstract class SearchFoodCategoryEvent extends Equatable {
  const SearchFoodCategoryEvent();

  @override
  List<Object> get props => [];
}

class SearchSubmitted extends SearchFoodCategoryEvent {
  final String query;
  final int pageNumber;
  const SearchSubmitted({required this.query, required this.pageNumber});

  @override
  List<Object> get props => [query, pageNumber];
}

class GetCategorySuggestion extends SearchFoodCategoryEvent {}

//* Selection food category event
class SelectFoodCategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectFoodCategory extends SelectFoodCategoryEvent {
  final String foodCategory;
  SelectFoodCategory({required this.foodCategory});

  @override
  List<Object> get props => [foodCategory];
}

class UnselectFoodCategory extends SelectFoodCategoryEvent {
  final String foodCategory;
  UnselectFoodCategory({required this.foodCategory});

  @override
  List<Object> get props => [foodCategory];
}

class CreateNewCategory extends SelectFoodCategoryEvent {
  final String foodCategory;
  CreateNewCategory({required this.foodCategory});

  @override
  List<Object> get props => [foodCategory];
}

class ResetCategoryEvent extends SelectFoodCategoryEvent {
  ResetCategoryEvent();

  @override
  List<Object> get props => [];
}
