import 'package:flutter/material.dart';
import 'package:quiz/pages/quiz_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Stranger Things',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: QuizPage(),
    );
  }
}
