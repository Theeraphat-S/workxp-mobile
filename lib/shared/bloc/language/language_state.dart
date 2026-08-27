import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// State representing current active language/locale.
class LanguageState extends Equatable {
  const LanguageState(this.locale);

  final Locale locale;

  String get languageCode => locale.languageCode;
  bool get isThai => locale.languageCode == 'th';
  bool get isEnglish => locale.languageCode == 'en';

  @override
  List<Object?> get props => [locale];
}
