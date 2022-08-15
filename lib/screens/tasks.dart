import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/tasks_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? taskCategory;

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
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('taskCategory', isEqualTo: taskCategory)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active ) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return TaskWidget(
                          title: snapshot.data!.docs[index]['taskTitle'],
                          subTitle: snapshot.data!.docs[index]['taskCategory'],
                          descrption: snapshot.data!.docs[index]
                              ['taskDescription'],
                          isDone: snapshot.data!.docs[index]['isDone'],
                          uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                          taskId: snapshot.data!.docs[index]['taskId'],
                        );
                      });
                } else {
                  return const Center(
                    child: Text('No data Found'),
                  );
                }
              } else {
                return const Center(
                  child: Text('No data Found'),
                );
              }
            })));
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
            content: SizedBox(
              height: 200,
              width: 100,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AppConstants.category.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        taskCategory = AppConstants.category[index];
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      });
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
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    taskCategory = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel filter'),
              ),
            ],
          );
        });
  }
}
