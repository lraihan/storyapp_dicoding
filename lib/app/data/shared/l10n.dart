import 'package:flutter/material.dart';
import 'l10n_en.dart';
import 'l10n_id.dart';

abstract class L10n {
  L10n([String locale = 'en']);

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];

  String get appTitle;
  String get login;
  String get register;
  String get email;
  String get password;
  String get name;
  String get confirmPassword;
  String get loginButton;
  String get registerButton;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get stories;
  String get addStory;
  String get logout;
  String get description;
  String get camera;
  String get gallery;
  String get upload;
  String get loading;
  String get error;
  String get noData;
  String get tryAgain;
  String get success;
  String get storyUploaded;
  String get pleaseSelectImage;
  String get pleaseEnterDescription;
  String get emailRequired;
  String get passwordRequired;
  String get nameRequired;
  String get passwordMismatch;
  String get invalidEmail;
  String get passwordTooShort;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return _lookupL10n(locale);
  }

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

Future<L10n> _lookupL10n(Locale locale) async {
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'id':
      return L10nId();
  }

  throw FlutterError('L10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
