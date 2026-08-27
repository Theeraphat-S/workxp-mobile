import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all LanguageBloc events.
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the saved language preference from Hive.
class LoadLanguage extends LanguageEvent {
  const LoadLanguage();
}

/// Event to change the application language at runtime.
class ChangeLanguage extends LanguageEvent {
  const ChangeLanguage(this.locale);

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}
