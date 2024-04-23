import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:todofinal/todo_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Конектит проект с firebase
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyAu6wP3M2ognPh7zmbrVzUPpP5WjuzFQ-0',
              appId: '1:696936217540:android:e5fa1eba920c8ae83a0291',
              messagingSenderId: '696936217540',
              projectId: 'todofinal-78466'))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoList(),
    );
  }
}
