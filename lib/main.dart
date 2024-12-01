import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:meals_app/firebase_options.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/screens/splash_screen.dart';

final theme = ThemeData(
    appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.dancingScript(
            textStyle: ThemeData.light()
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 33))),
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      //brightness: Brightness.dark, //dark, light, values
      seedColor: Colors.teal,
    ));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const SplashScreen()),
    ),
  );
}
