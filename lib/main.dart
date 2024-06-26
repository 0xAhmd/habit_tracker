import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:habits/db/habit_database.dart';
import 'package:habits/pages/home_page.dart';
import 'package:habits/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize db
  await HabitDataBase.initialize();
  await HabitDataBase.saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitDataBase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          theme: themeProvider.themeData,
        );
      },
    );
  }
}
