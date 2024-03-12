part of 'total_price_bloc.dart';

abstract class TotalPriceEvent extends Equatable {
  const TotalPriceEvent();

  @override
  List<Object> get props => [];
}

class GetOrderTotalPriceEvent extends TotalPriceEvent {
  final Map<Item, int> cart;

  const GetOrderTotalPriceEvent({
    required this.cart,
  });
}
