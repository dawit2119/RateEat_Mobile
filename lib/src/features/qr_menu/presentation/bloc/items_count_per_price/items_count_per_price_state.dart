import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class ItemsCountPerPriceState extends Equatable {
  const ItemsCountPerPriceState();
}

class ItemsCountPerPriceLoaded extends ItemsCountPerPriceState {
  final List<PriceRange> priceRanges;

  const ItemsCountPerPriceLoaded({
    required this.priceRanges,
  });

  @override
  List<Object?> get props => [priceRanges];
}

class ItemsCountPerPriceFailed extends ItemsCountPerPriceState {
  final String message;

  const ItemsCountPerPriceFailed({required this.message});

  @override
  List<Object?> get props => [message];
}

class ItemsCountPerPriceLoading extends ItemsCountPerPriceState {
  const ItemsCountPerPriceLoading();

  @override
  List<Object?> get props => [];
}

class ItemsCountPerPriceInitial extends ItemsCountPerPriceState {
  const ItemsCountPerPriceInitial();

  @override
  List<Object?> get props => [];
}
