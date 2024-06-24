import 'package:flutter/material.dart';
import 'package:habits/db/habit_dataBase.dart';
import 'package:habits/pages/home_page.dart';
import 'package:habits/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize db
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
