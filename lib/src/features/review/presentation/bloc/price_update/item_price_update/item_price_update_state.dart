import 'package:equatable/equatable.dart';

abstract class ItemPriceChangeState extends Equatable {
  const ItemPriceChangeState();
  @override
  List<Object> get props => [];
}

class ItemPriceChangeInitial extends ItemPriceChangeState {}

class ItemPriceChangeLoading extends ItemPriceChangeState {}

class ItemPriceChangeSuccess extends ItemPriceChangeState {
  final String message;
  const ItemPriceChangeSuccess({required this.message});
}

class ItemPriceChangeError extends ItemPriceChangeState {
  final String error;
  const ItemPriceChangeError({required this.error});
}
