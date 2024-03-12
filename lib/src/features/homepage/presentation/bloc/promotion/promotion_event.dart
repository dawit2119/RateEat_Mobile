part of 'promotion_bloc.dart';

abstract class PromotionEvent extends Equatable {
  const PromotionEvent();

  @override
  List<Object> get props => [];
}

final class GetPromotionEvent extends PromotionEvent {
  final int page;
  final int limit;

  const GetPromotionEvent({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
