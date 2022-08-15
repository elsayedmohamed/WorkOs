import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../core/utils.dart';
import '../inner_screens/task_details.dart';

class TaskWidget extends StatefulWidget {
  final String title;
  final String subTitle;
  final String descrption;
  final String taskId;

  bool isDone = false;
  final String uploadedBy;

  TaskWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.descrption,
    required this.isDone,
    required this.uploadedBy,
    required this.taskId,
  }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        onTap: () {
          navigateToPage(
              context,
              TaskDetailScreen(
                taskId: widget.taskId,
                uploadedBy: widget.uploadedBy,
              ));
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        User? user = auth.currentUser;
                        final uuid = user!.uid;

                        if (uuid == widget.uploadedBy) {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(widget.taskId)
                                .delete();
                            Navigator.pop(context);
                          });
                        } else {
                          showToast('Task creater can be only delete this task',
                          context,
                              duration: 4);
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }));
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            // https://image.flaticon.com/icons/png/128/850/850960.png
            child: Image.network(
              widget.isDone
                  ? 'https://vignette.wikia.nocookie.net/scream-queens/images/d/d6/Right.png/revision/latest?cb=20151213161824'
                  : 'https://www.clipartmax.com/png/full/366-3668222_funny-of-timers-clipart-waste-time-icon-png.png',
              fit: BoxFit.fill,
              height: 100,
              width: 100,
            ),
          ),
        ),
        title: Text(
          widget.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pink.shade800,
            ),
            Text(
              '${widget.subTitle} - ${widget.descrption} ',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.pink[800],
        ),
      ),
    );
  }

  
}


