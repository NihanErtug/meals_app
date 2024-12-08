import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:meals_app/firebase_options.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/theme_notifier.dart';

import 'package:meals_app/screens/splash_screen.dart';

/* final theme = ThemeData(
    appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.dancingScript(
            textStyle:
                ThemeData().textTheme.headlineLarge?.copyWith(fontSize: 33))),
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark, //dark, light, values
      seedColor: Colors.teal,
    )); */

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.black,
    titleTextStyle: GoogleFonts.dancingScript(
      textStyle:
          ThemeData.light().textTheme.headlineLarge?.copyWith(fontSize: 33),
    ),
  ),
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal, brightness: Brightness.light),
);

final darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    titleTextStyle: GoogleFonts.dancingScript(
      textStyle:
          ThemeData.dark().textTheme.headlineLarge?.copyWith(fontSize: 33),
    ),
  ),
  useMaterial3: true,
  colorScheme:
      ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadThemePreferences();

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => themeNotifier),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}
