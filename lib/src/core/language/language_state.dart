import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/language/language.dart';

class LanguageState extends Equatable {
  final Language selectedLanguage;
  LanguageState({
    Language? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? getCurrentLanguage();

  @override
  List<Object> get props => [selectedLanguage];

  LanguageState copyWith({Language? selectedLanguage}) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

Language getCurrentLanguage() {
  final languageState = Hive.box<String>('language');
  final currentLanguage = languageState.get(0);

  if (currentLanguage == "English") {
    return Language.english;
  } else if (currentLanguage == "Amharic") {
    return Language.amharic;
  } else if (currentLanguage == "Afaan Oromoo") {
    return Language.afaanOromoo;
  } else if (currentLanguage == "Swahili") {
    return Language.swahili;
  } else if (currentLanguage == "French") {
    return Language.french;
  } else if (currentLanguage == "Kinyarwanda") {
    return Language.kinyarwanda;
  } else if (currentLanguage == "Arabic") {
    return Language.arabic;
  } else if (currentLanguage == "Spanish") {
    return Language.spanish;
  } else if (currentLanguage == "Luganda") {
    return Language.luganda;
  } else if (currentLanguage == "Kirundi") {
    return Language.kirundi;
  } else if (currentLanguage == "Russian") {
    return Language.russian;
  } else if (currentLanguage == "Somali") {
    return Language.somali;
  } else if (currentLanguage == "Tigrinya") {
    return Language.tigrinya;
  } else if (currentLanguage == "Turkish") {
    return Language.turkish;
  }

  return Language.english;
}
