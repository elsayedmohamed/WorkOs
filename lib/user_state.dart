import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos/screens/auth/login.dart';
import 'package:workos/screens/tasks.dart';

class UserStateScreen extends StatelessWidget {
  const UserStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.data == null) {
            return const LoginScreen();
          } else if (userSnapshot.hasData) {
            return TasksScreen();
          } else if (userSnapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Error occured')),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Error occured')),
          );
        });
  }
}
