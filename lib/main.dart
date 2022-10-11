import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase_app/screen/display.dart';
import 'package:test_firebase_app/screen/form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        body: TabBarView(
          children: [
            FormScreen(),
            DisplayScreen(),
          ],
        ),
        backgroundColor: Colors.blue,
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(text: "บันทึกคะแนนสอบ"),
            Tab(text: "รายชื่อนักเรียน"),
          ],
        ),
      ),
    );
  }
}
