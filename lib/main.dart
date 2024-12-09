import 'package:flutter/material.dart';
import 'package:habittute/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'database/habit_database.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetFlutterBinding.ensureInitialized();
  // initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()
      child: const MyApp(),
    ), // ChangeNotifierProvider
  );
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});
}

@override 
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: Provider.of<ThemeProvider>(context).themeData,
  ); // MaterialApp
}