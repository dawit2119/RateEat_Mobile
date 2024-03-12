import 'package:equatable/equatable.dart';

abstract class PriceChangeState extends Equatable {
  const PriceChangeState();
  @override
  List<Object> get props => [];
}

class PriceChangeInitial extends PriceChangeState {}

class PriceChangeLoading extends PriceChangeState {}

class PriceChangeSuccess extends PriceChangeState {
  final String message;
  const PriceChangeSuccess({required this.message});
}

class PriceChangeError extends PriceChangeState {
  final String error;
  const PriceChangeError({required this.error});
}
