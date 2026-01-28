// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tekachigeojit/prep/Techincal%20Training/OOPtopics.dart';
import 'login.dart';
import 'signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const TekachiGeo());
}

class TekachiGeo extends StatelessWidget {
  const TekachiGeo({super.key});

  @override
  Widget build(BuildContext context) {  
    
    return MaterialApp(
        title: 'Tekachi',
        home: const TechnicalTopics()
    );
  }
}
