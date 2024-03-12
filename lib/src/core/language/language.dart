import 'package:flutter/material.dart';

enum Language {
  english(
    Locale('en'),
    'English',
  ),
  amharic(
    Locale('am'),
    'Amharic',
  ),
  afaanOromoo(
    Locale('or'),
    'Afaan Oromoo',
  ),
  swahili(
    Locale('sw'),
    'Swahili',
  ),
  french(
    Locale('fr'),
    'French',
  ),
  // cspell:ignore kinyarwanda
  kinyarwanda(
    Locale('rw'),
    'Kinyarwanda',
  ),
  arabic(
    Locale('ar'),
    'Arabic',
  ),
  spanish(
    Locale('es'),
    'Spanish',
  ),
  luganda(
    Locale('lg'),
    'Luganda',
  ),
  kirundi(
    Locale('rn'),
    'Kirundi',
  ),
  russian(
    Locale('ru'),
    'Russian',
  ),
  somali(
    Locale('so'),
    'Somali',
  ),
  tigrinya(
    Locale('ti'),
    'Tigrinya',
  ),
  turkish(
    Locale('tr'),
    'Turkish',
  ),
  ;

  /// Add another languages support here
  const Language(this.value, this.text);

  final Locale value;

  final String text; // Optional: this properties used for ListTile details
}
