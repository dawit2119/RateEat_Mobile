import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/domain/usecases/convert_currency_usecase.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/presentation/bloc/currency_event.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/presentation/bloc/currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final ConvertCurrencyUseCase convertCurrencyUseCase;

  CurrencyBloc({required this.convertCurrencyUseCase})
      : super(CurrencyInitial()) {
    on<ConvertCurrencyEvent>(_onConvertCurrency);
    on<UpdateRestaurantCurrencyEvent>(_onUpdateRestaurantCurrency);
  }

  Future<void> _onConvertCurrency(
    ConvertCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    final result = await convertCurrencyUseCase(
      ConvertCurrencyParams(
        from: event.from,
        to: event.to,
        amount: event.amount,
      ),
    );
    result.fold(
      (failure) => emit(
          CurrencyError(message: failure.errorMessage ?? 'Conversion failed')),
      (conversion) => emit(CurrencySuccess(conversion: conversion)),
    );
  }

  Future<void> _onUpdateRestaurantCurrency(
    UpdateRestaurantCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    if (event.fromCurrency == event.targetCurrency) {
      emit(CurrencyRateUpdated(
        fromCurrency: event.fromCurrency,
        targetCurrency: event.targetCurrency,
        exchangeRate: 1.0,
      ));
      return;
    }

    emit(CurrencyLoading());

    // We request conversion for 1.0 unit just to get the rate
    final result = await convertCurrencyUseCase(
      ConvertCurrencyParams(
        from: event.fromCurrency,
        to: event.targetCurrency,
        amount: 1.0,
      ),
    );

    result.fold(
      (failure) =>
          emit(CurrencyError(message: failure.errorMessage ?? 'Update failed')),
      (conversion) {
        // FIX: Use conversion.exchangeRate directly.
        // This prevents the "0" issue when convertedAmount is rounded down.
        emit(CurrencyRateUpdated(
          fromCurrency: event.fromCurrency,
          targetCurrency: event.targetCurrency,
          exchangeRate: conversion.exchangeRate,
        ));
      },
    );
  }
}
