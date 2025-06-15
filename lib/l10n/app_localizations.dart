import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());
  final String localeName;
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];
  String get appName;
  String get login;
  String get register;
  String get email;
  String get password;
  String get name;
  String get loginButton;
  String get registerButton;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get logout;
  String get stories;
  String get addStory;
  String get addNewStory;
  String get description;
  String get selectImage;
  String get uploadStory;
  String get loading;
  String get error;
  String get noData;
  String get loginSuccess;
  String get loginFailed;
  String get registerSuccess;
  String get registerFailed;
  String get uploadSuccess;
  String get uploadFailed;
  String get pleaseEnterEmail;
  String get pleaseEnterPassword;
  String get pleaseEnterName;
  String get pleaseEnterDescription;
  String get pleaseSelectImage;
  String get invalidEmail;
  String get passwordTooShort;
  String get storyDetail;
  String get tapToSelectImage;
  String get enterDescription;
  String get success;
  String get retry;
  String get storyLocation;
  String get selectLocation;
  String get selectedLocation;
  String get confirmLocation;
  String get unknownLocation;
  String get locationServiceDisabled;
  String get pleaseEnableLocationService;
  String get locationPermissionDenied;
  String get locationPermissionRequired;
  String get locationPermissionDeniedPermanently;
  String get pleaseEnableLocationInSettings;
  String get location;
  String get tapToSelectLocation;
  String get locationNotAvailableInFreeVersion;
  String get locationFeatureNotAvailable;
  String get loadingAddress;
  String get locationServicesDisabled;
  String get locationServicesMessage;
  String get locationPermissionMessage;
  String get openSettings;
  String get cancel;
  String get timeout;
  String get locationTimeout;
  String get failedToGetLocation;
  String get gettingCurrentLocation;
  String get locationObtained;
  String get locationAvailable;
  String get mapUnavailable;
  String get useCurrentLocation;
  String get getCurrentLocationDesc;
  String get manualCoordinates;
  String get latitude;
  String get longitude;
  String get locationHelp;
  String get locationHelpDesc;
  String get address;
  String get addressNotFound;
  String get close;
  String get viewFullScreen;
}
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }
  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }
  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
