// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tekachigeojit/apptheme.dart';
import 'package:tekachigeojit/home.dart';
import 'package:tekachigeojit/prep/HRQuestions.dart';
import 'package:tekachigeojit/prep/prepHome.dart';
import 'package:tekachigeojit/userSettings/userSettings.dart';
import 'login.dart';
import 'signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const TekachiGeo());
}

class TekachiGeo extends StatelessWidget {
  const TekachiGeo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tekachi',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
