import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class SearchFoodCategoryState extends Equatable {
  const SearchFoodCategoryState();

  @override
  List<Object> get props => [];
}

//* Search States
class SearchInitial extends SearchFoodCategoryState {}

class SearchLoading extends SearchFoodCategoryState {}

class SearchSuccess extends SearchFoodCategoryState {
  final List<ItemCategoryModel> itemCategories;

  const SearchSuccess(this.itemCategories);

  @override
  List<Object> get props => [itemCategories];
}

class SearchError extends SearchFoodCategoryState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}

//* Manage selected food category
class SelectedFoodCategoryState extends Equatable {
  final List<String> selectedCategories;

  const SelectedFoodCategoryState(this.selectedCategories);

  @override
  List<Object> get props => [selectedCategories];
}
