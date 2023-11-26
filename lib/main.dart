import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:santander_meal/shared/app_themes.dart';
import 'package:santander_meal/shared/constants.dart';
import 'package:santander_meal/views/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      themeMode: ThemeMode.dark,
      darkTheme: AppThemes.dracula,
      home: const MainPage(),
    );
  }
}
