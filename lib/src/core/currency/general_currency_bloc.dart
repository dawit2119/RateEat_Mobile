import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'currency.dart';

abstract class GeneralCurrencyEvent {}

class LoadGeneralCurrency extends GeneralCurrencyEvent {}

class ChangeGeneralCurrency extends GeneralCurrencyEvent {
  final Currency selectedCurrency;
  ChangeGeneralCurrency({required this.selectedCurrency});
}

abstract class GeneralCurrencyState {
  final Currency selectedCurrency;
  const GeneralCurrencyState({required this.selectedCurrency});
}

class GeneralCurrencyInitial extends GeneralCurrencyState {
  const GeneralCurrencyInitial({required super.selectedCurrency});
}

class GeneralCurrencyChanged extends GeneralCurrencyState {
  const GeneralCurrencyChanged({required super.selectedCurrency});
}

class GeneralCurrencyBloc
    extends Bloc<GeneralCurrencyEvent, GeneralCurrencyState> {
  GeneralCurrencyBloc()
      : super(
            const GeneralCurrencyInitial(selectedCurrency: Currency.original)) {
    on<LoadGeneralCurrency>(_onLoadCurrency);
    on<ChangeGeneralCurrency>(_onChangeCurrency);
  }

  void _onLoadCurrency(
      LoadGeneralCurrency event, Emitter<GeneralCurrencyState> emit) {
    final currencyBox = Hive.box<String>('currency');
    final savedCurrency =
        currencyBox.get(0, defaultValue: Currency.original.code);
    final currency = Currency.fromCode(savedCurrency!);
    emit(GeneralCurrencyChanged(selectedCurrency: currency));
  }

  void _onChangeCurrency(
      ChangeGeneralCurrency event, Emitter<GeneralCurrencyState> emit) {
    final currencyBox = Hive.box<String>('currency');
    currencyBox.put(0, event.selectedCurrency.code);
    emit(GeneralCurrencyChanged(selectedCurrency: event.selectedCurrency));
  }
}
