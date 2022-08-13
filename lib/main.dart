import 'package:flutter/material.dart';
import 'package:workos/screens/tasks.dart';

import 'screens/auth/signup.dart';

void main() {
  runApp(const WorkOs());
}

class WorkOs extends StatelessWidget {
  const WorkOs({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEDE7DC),
        primarySwatch: Colors.blue,
      ),
      home: TasksScreen(),
    );
  }
}
