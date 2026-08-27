import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/config/config.dart';
import 'package:workxp/domain/datasource/hive_config.dart';
import 'package:workxp/i18n/i18n.dart';
import 'package:workxp/locator.dart';
import 'package:workxp/router/router.dart';
import 'package:workxp/shared/bloc/language/language_bloc.dart';
import 'package:workxp/shared/theme/pixel_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup GetIt locator if not already initialized
  if (!locator.isRegistered<AppConfig>()) {
    await setupLocator();
  }

  runApp(const WorkXpApp());
}

class WorkXpApp extends StatefulWidget {
  const WorkXpApp({super.key, this.appRouter, this.languageBloc});

  final AppRouter? appRouter;
  final LanguageBloc? languageBloc;

  @override
  State<WorkXpApp> createState() => _WorkXpAppState();
}

class _WorkXpAppState extends State<WorkXpApp> {
  late final AppRouter _router;
  late final LanguageBloc _languageBloc;

  @override
  void initState() {
    super.initState();
    _router =
        widget.appRouter ??
        (locator.isRegistered<AppRouter>()
            ? locator<AppRouter>()
            : AppRouter());

    _languageBloc =
        widget.languageBloc ??
        (locator.isRegistered<LanguageBloc>()
            ? locator<LanguageBloc>()
            : LanguageBloc(HiveConfig()));

    if (!locator.isRegistered<AppConfig>()) {
      setupLocator(
        loadEnvFile: false,
        initHive: false,
        customRouter: _router,
        customLanguageBloc: _languageBloc,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageBloc>.value(
      value: _languageBloc,
      child: BlocBuilder<LanguageBloc, LanguageState>(
        bloc: _languageBloc,
        builder: (context, languageState) {
          return MaterialApp.router(
            title: 'WorkXP (Pocket Quest)',
            debugShowCheckedModeBanner: false,
            theme: PixelTheme.darkTheme(),
            locale: languageState.locale,
            localizationsDelegates: const [
              I18n.delegate,
              _FallbackMaterialLocalizationsDelegate(),
              _FallbackWidgetsLocalizationsDelegate(),
              _FallbackCupertinoLocalizationsDelegate(),
            ],
            supportedLocales: I18n.supportedLocales,
            routerConfig: _router.config(),
            builder: (context, child) {
              return BlocProvider<LanguageBloc>.value(
                value: _languageBloc,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

class _FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return DefaultMaterialLocalizations.load(locale);
  }

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}

class _FallbackWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _FallbackWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return DefaultWidgetsLocalizations.load(locale);
  }

  @override
  bool shouldReload(_FallbackWidgetsLocalizationsDelegate old) => false;
}

class _FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return DefaultCupertinoLocalizations.load(locale);
  }

  @override
  bool shouldReload(_FallbackCupertinoLocalizationsDelegate old) => false;
}
