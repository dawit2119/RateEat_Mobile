import 'package:equatable/equatable.dart';

class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {
  final String restaurantId;
  GetCategoriesEvent({required this.restaurantId});
}
