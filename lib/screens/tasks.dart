import 'package:flutter/material.dart';
import 'package:workos/constants.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/tasks_widget.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              showCategoriesDialog(context);
            },
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(itemBuilder: (context, index) {
        return const TaskWidget();
      }),
    );
  }

  Future<dynamic> showCategoriesDialog(BuildContext context) {
    return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Task category',
                      style: TextStyle(color: Colors.pink.shade800),
                    ),
                    content: Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: AppConstants.category.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              print(AppConstants.category[index]);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.red[200],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(AppConstants.category[index]),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        child: const Text('Cancel filter'),
                      ),
                    ],
                  );
                });
  }
}
