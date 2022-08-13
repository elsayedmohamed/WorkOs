import 'package:flutter/material.dart';
import 'package:workos/constants.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({Key? key}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Task Title',
                style: TextStyle(
                  color: AppConstants.kDarkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Text(
                              'Uploaded by ',
                              style: TextStyle(
                                color: AppConstants.kDarkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Uploaded name',
                                      style: TextStyle(
                                        color: AppConstants.kDarkBlue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        textBaseline: TextBaseline.alphabetic,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Uploades job',
                                      style: TextStyle(
                                        color: AppConstants.kDarkBlue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        textBaseline: TextBaseline.alphabetic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded on:',
                            style: TextStyle(
                              color: AppConstants.kDarkBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                          Text(
                            'date: 16-05-1987',
                            style: TextStyle(
                              color: AppConstants.kDarkBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deadline date:',
                            style: TextStyle(
                              color: AppConstants.kDarkBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                          Text(
                            'date: 16-05-1987',
                            style: TextStyle(
                              color: AppConstants.kDarkBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                            'date: 16-05-1987',
                            style: TextStyle(
                              color: AppConstants.kDarkBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                'Done state: ',
                                style: TextStyle(
                                  color: AppConstants.kDarkBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
