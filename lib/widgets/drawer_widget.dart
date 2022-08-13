// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:workos/constants.dart';
import 'package:workos/inner_screens/add_task.dart';
import 'package:workos/screens/all_workwers.dart';
import 'package:workos/screens/profile_page.dart';
import 'package:workos/screens/tasks.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.cyan,
            ),
            child: Column(
              children: [
                Flexible(
                  child: Image.network(
                    'https://img1.pnghut.com/t/25/13/7/jxMSA8CFAD/project-symbol-action-item-text-area.jpg',
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Work OS',
                  style: TextStyle(
                    color: AppConstants.kDarkBlue,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          ListTielsWidget(
              text: 'All tasks',
              icon: Icons.task_outlined,
              onTap: () {
                navigateToPage(context, TasksScreen());
              }),
          ListTielsWidget(
              onTap: () {
                navigateToPage(context, ProfilePage());
              },
              text: 'My account',
              icon: Icons.settings_outlined),
          ListTielsWidget(
              text: 'Registerd workers',
              icon: Icons.workspaces_outline,
              onTap: () {
                navigateToPage(context, AllWorkers());
              }),
          ListTielsWidget(
              text: 'Add task',
              icon: Icons.add_task_outlined,
              onTap: () {
                print('task add presed');
                navigateToPage(context, AddTaskScreen());
              }),
          const Divider(
            thickness: 1,
          ),
          ListTielsWidget(
              text: 'Logout',
              icon: Icons.logout_outlined,
              onTap: () {
                showsignOutdialog(context);
              }),
        ],
      ),
    );
  }

  Future<Object?> navigateToPage(BuildContext context, Widget screen) async {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }
}

void showsignOutdialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout_outlined,
                  color: AppConstants.kDarkBlue,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Signout'),
              ),
            ],
          ),
          content: const Text('Do you want to singnout'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                'cancel',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: AppConstants.kDarkBlue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      });
}

class ListTielsWidget extends StatelessWidget {
  ListTielsWidget({
    required this.onTap,
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);
  Function() onTap;
  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
