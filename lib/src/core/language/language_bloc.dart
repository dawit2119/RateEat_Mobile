import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/language/language_event.dart';
import 'package:rateeat_mobile/src/core/language/language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState()) {
    on<ChangeLanguage>(onChangeLanguage);
  }

  onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) {
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }
}
