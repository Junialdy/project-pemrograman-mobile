import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habittute/theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        backgroundColor: Colors.grey, // Set background color AppBar ke abu-abu
      ),
      drawer: Drawer(
        child: Center(
          // Menggunakan Center untuk menempatkan switch di tengah
          child: CupertinoSwitch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(); // Ganti tema
            },
          ),
        ),
      ),
      body: const Center(
        child: Text("THIS IS HOMEPAGE"),
      ),
    );
  }
}
