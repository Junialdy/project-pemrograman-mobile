import 'package:flutter/material.dart';
import 'package:habittute/theme/dark_mode.dart';
import 'package:habittute/theme/light_mode.dart';
import 'package:habittute/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Akses ThemeProvider dari context
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context)
          .currentTheme, // Tema berdasarkan ThemeProvider
    );
  }
}
