import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:animehome/presentation/main_navigation.dart';
import 'package:animehome/presentation/likes/likes_provider.dart';
import 'package:animehome/presentation/settings/settings_provider.dart';
import 'package:animehome/presentation/auth/auth_provider.dart';
import 'package:animehome/presentation/auth/welcome_screen.dart';
import 'package:animehome/l10n/app_localizations.dart';

import 'package:animehome/presentation/home/hybrid_anime_provider.dart';
import 'package:animehome/presentation/theme/theme_provider.dart';
import 'package:animehome/data/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive'ni initialize qilish
  await HiveService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (context) => LikesProvider()..init()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()..init()),
        ChangeNotifierProvider(
          create: (context) => HybridAnimeProvider()..init(),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, AuthProvider>(
      builder: (context, settingsProvider, authProvider, child) {
        return MaterialApp(
          title: 'Anime Home',
          debugShowCheckedModeBanner: false,
          locale: Locale(settingsProvider.language),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: settingsProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: _getHomeScreen(authProvider),
        );
      },
    );
  }

  Widget _getHomeScreen(AuthProvider authProvider) {
    // Auth provider hali yuklanayotgan bo'lsa
    if (authProvider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
        ),
      );
    }

    // Foydalanuvchi tizimga kirganmi?
    if (authProvider.isLoggedIn) {
      return const MainNavigation();
    } else {
      return const WelcomeScreen();
    }
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
      cardColor: Colors.grey[100],
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
      cardColor: const Color(0xFF2A2A2A),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      useMaterial3: true,
    );
  }
}
