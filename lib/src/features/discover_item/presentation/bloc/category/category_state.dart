import 'package:equatable/equatable.dart';

import '../../../data/models/catagory_model.dart';

class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  const CategoryLoaded({required this.categories});
  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String error;
  const CategoryError({required this.error});
  @override
  List<Object> get props => [error];
}
