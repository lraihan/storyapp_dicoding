import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/service/api_service.dart';
import 'app/data/service/preferences_service.dart';
import 'app/data/service/location_service.dart';
import 'app/data/shared/app_config.dart';
import 'l10n/app_localizations.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await GetStorage.init();

  AppConfig.setFlavor(AppFlavor.free);

  Get.put(PreferencesService());
  Get.put(ApiService());
  Get.put(LocationService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final preferencesService = Get.find<PreferencesService>();
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(preferencesService.getLanguage()),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      routerConfig: AppRouter.router,
    );
  }
}
