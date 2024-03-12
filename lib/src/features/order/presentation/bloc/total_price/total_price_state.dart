part of 'total_price_bloc.dart';

abstract class TotalPriceState extends Equatable {
  const TotalPriceState();

  @override
  List<Object> get props => [];
}

class TotalPriceInitial extends TotalPriceState {}

class TotalPriceLoading extends TotalPriceState {}

class TotalPriceLoaded extends TotalPriceState {
  final TotalPrice totalPrice;

  const TotalPriceLoaded({
    required this.totalPrice,
  });
}

class TotalPriceFailed extends TotalPriceState {
  final String errorMessage;

  const TotalPriceFailed({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
