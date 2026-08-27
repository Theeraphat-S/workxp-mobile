import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/datasource/hive_config.dart';
import 'language_event.dart';
import 'language_state.dart';

export 'language_event.dart';
export 'language_state.dart';

/// BLoC managing application language switching and local persistence.
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc(this._hiveConfig)
      : super(LanguageState(Locale(_hiveConfig.locale))) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  final HiveConfig _hiveConfig;

  void _onLoadLanguage(LoadLanguage event, Emitter<LanguageState> emit) {
    final savedCode = _hiveConfig.locale;
    emit(LanguageState(Locale(savedCode)));
  }

  void _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) {
    emit(LanguageState(event.locale));
    _hiveConfig.setLocale(event.locale.languageCode);
  }
}
