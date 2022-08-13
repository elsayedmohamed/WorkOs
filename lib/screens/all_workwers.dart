import 'package:flutter/material.dart';
import 'package:workos/constants.dart';
import 'package:workos/widgets/all_workers_widget%20.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/tasks_widget.dart';

class AllWorkers extends StatelessWidget {
  AllWorkers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('All Workers'),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(itemBuilder: (context, index) {
        return const AllworkersWidget();
      }),
    );
  }
}
