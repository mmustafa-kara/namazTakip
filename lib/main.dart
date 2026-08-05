import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/theme.dart';
import 'services/local_storage_service.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Türkçe tarih formatları için intl locale'i başlat
  await initializeDateFormatting('tr_TR');

  // Portre yönünü sabitle
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparan status bar (edge-to-edge görünüm)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Hive yerel veritabanını başlat
  await Hive.initFlutter();
  final localDb = LocalStorageService();
  await localDb.init();

  runApp(const ProviderScope(child: EzanVaktiApp()));
}

/// Uygulamanın kök widget'ı.
class EzanVaktiApp extends ConsumerWidget {
  const EzanVaktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO (Faz 2 tamamlanınca): themeProvider ile dinamik tema geçişi
    const themeMode = ThemeMode.dark;

    return MaterialApp(
      title: 'Ezan Vakti Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Türkçe tarih ve genel lokalizasyon desteği
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Faz 4: Gerçek ana ekran
      home: const HomeView(),
    );
  }
}
