import 'package:equatable/equatable.dart';

import '../../../../homepage/domain/entities/item.dart';

class ItemDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemDetailInitial extends ItemDetailState {}

class ItemDetailLoading extends ItemDetailState {}

class ItemDetailSuccess extends ItemDetailState {
  final Item item;
  final bool isLocal;
  ItemDetailSuccess({required this.item, required this.isLocal});
  @override
  List<Object?> get props => [item, isLocal];
}

class ItemDetailError extends ItemDetailState {
  final String error;
  ItemDetailError({required this.error});
  @override
  List<Object?> get props => [error];
}
