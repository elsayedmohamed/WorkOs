import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workos/constants.dart';
import '../core/utils.dart';
import '../widgets/comment_widget.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  final String uploadedBy;

  const TaskDetailScreen({
    Key? key,
    required this.taskId,
    required this.uploadedBy,
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  String? _authorName;
  String? _authorPosition;
  String? _taskDescription;
  String? _taskTitle;
  String? imageUrl;
  String? positon;
  bool? isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadDateTimeStamp;
  bool isCommenting = false;
  String? deadLineDate;
  String? postedDate;
  bool isDeadLineAvaliable = false;
  bool isLoading = false;
  TextEditingController commentController = TextEditingController();

  void getData() async {
    try {
      isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          _authorName = userDoc.get('name');
          _authorPosition = userDoc.get('position');
          imageUrl = userDoc.get('image');
          positon = userDoc.get('position');
        });
      }
      final DocumentSnapshot taskDoc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();
      if (taskDoc == null) {
        return;
      } else {
        setState(() {
          isDone = taskDoc.get('isDone');
          _taskDescription = taskDoc.get('taskDescription');
          _taskTitle = taskDoc.get('taskTitle');

          postedDateTimeStamp = taskDoc.get('createdAt');
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
          deadDateTimeStamp = taskDoc.get('deadLineDateTimeStamp');
          var date = deadDateTimeStamp!.toDate();
          isDeadLineAvaliable = date.isAfter(DateTime.now());

          deadLineDate = taskDoc.get('deadLineDate');
          //postedDate = taskDoc.get('deadLineDate');
          //isDeadLineAvaliable = false;
        });
      }
    } on Exception {
      isLoading = false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 18,
                color: AppConstants.kDarkBlue,
              ),
            )),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Loading Data',
                      style: TextStyle(
                          color: AppConstants.kDarkBlue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LinearProgressIndicator(
                      color: AppConstants.kDarkBlue,
                    )
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        width: 50,
                                        height: 50,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 3,
                                            color: Colors.white,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl == null
                                                ? 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80'
                                                : imageUrl!),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _authorName == null
                                                ? ''
                                                : _authorName!,
                                            style: TextStyle(
                                              color: AppConstants.kDarkBlue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            positon == null ? '' : positon!,
                                            style: TextStyle(
                                              color: AppConstants.kDarkBlue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
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
                                  postedDate == null ? '' : postedDate!,
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
                                  deadLineDate == null ? '' : deadLineDate!,
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
                            Center(
                              child: Text(
                                isDeadLineAvaliable
                                    ? 'Still have enough time'
                                    : 'No time left',
                                style: TextStyle(
                                  color: isDeadLineAvaliable
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  textBaseline: TextBaseline.alphabetic,
                                ),
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
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          User? user = auth.currentUser;
                                          final usetUid = user!.uid;

                                          if (usetUid == widget.uploadedBy) {
                                            FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(widget.taskId)
                                                .update({
                                              'isDone': true,
                                            });

                                            getData();
                                          } else {
                                            showSnakError(
                                             
                                                'Only Task Creater can be change task status',context);
                                          }
                                        },
                                        child: Text(
                                          'Done',
                                          style: TextStyle(
                                            color: AppConstants.kDarkBlue,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                          ),
                                        )),
                                    Opacity(
                                      opacity: isDone == true ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          User? user = auth.currentUser;
                                          final usetUid = user!.uid;

                                          if (usetUid == widget.uploadedBy) {
                                            FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(widget.taskId)
                                                .update({
                                              'isDone': false,
                                            });

                                            getData();
                                          } else {
                                            showSnakError(
                                             
                                                'Only Task Creater can be change task status',context);
                                          }
                                        },
                                        child: Text(
                                          'Not done',
                                          style: TextStyle(
                                            color: AppConstants.kDarkBlue,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                          ),
                                        )),
                                    Opacity(
                                      opacity: isDone == false ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Task description',
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
                                  _taskDescription == null
                                      ? ''
                                      : _taskDescription!,
                                  style: TextStyle(
                                    color: AppConstants.kDarkBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    textBaseline: TextBaseline.alphabetic,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(
                                milliseconds: 900,
                              ),
                              child: isCommenting
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: TextField(
                                            controller: commentController,
                                            maxLength: 2000,
                                            maxLines: 6,
                                            keyboardType: TextInputType.text,
                                            enabled: true,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              hintText:
                                                  'Write your comment here',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.pink.shade700,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                height: 55,
                                                color: Colors.pink.shade600,
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  side: BorderSide.none,
                                                ),
                                                onPressed: () {
                                                  if (commentController
                                                          .text.length <
                                                      3) {
                                                    showSnakError(
                                                      
                                                        'Comment should be minimum 3 letters',context);
                                                  } else {
                                                    final String
                                                        generatedCommentId =
                                                        const Uuid().v4();

                                                    FirebaseFirestore.instance
                                                        .collection('tasks')
                                                        .doc(widget.taskId)
                                                        .update({
                                                      'taskComments': FieldValue
                                                          .arrayUnion([
                                                        {
                                                          'userId':
                                                              widget.uploadedBy,
                                                          'commentId':
                                                              generatedCommentId,
                                                          'name': _authorName,
                                                          'commentBody':
                                                              commentController
                                                                  .text,
                                                          'time':
                                                              Timestamp.now(),
                                                          'userImageUrl':
                                                              imageUrl,
                                                        }
                                                      ])
                                                    });
                                                    commentController.clear();
                                                    setState(() {});
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'Post',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              MaterialButton(
                                                height: 55,
                                                color: Colors.pink.shade600,
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  side: BorderSide.none,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isCommenting =
                                                        !isCommenting;
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : MaterialButton(
                                      height: 55,
                                      color: Colors.pink.shade600,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                        side: BorderSide.none,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isCommenting = !isCommenting;
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Add comment',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(widget.taskId)
                                    .get(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.data == null) {
                                    return Container();
                                  }

                                  return ListView.separated(
                                      reverse: true,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return CommentWidget(
                                          commentId:
                                              snapshot.data!['taskComments']
                                                  [index]['commentId'],
                                          commentBody:
                                              snapshot.data!['taskComments']
                                                  [index]['commentBody'],
                                          commenterName:
                                              snapshot.data!['taskComments']
                                                  [index]['name'],
                                          commentImagrUrl:
                                              snapshot.data!['taskComments']
                                                  [index]['userImageUrl'],
                                          commenterId:
                                              snapshot.data!['taskComments']
                                                  [index]['userId'],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 1,
                                        );
                                      },
                                      itemCount: snapshot
                                          .data!['taskComments'].length);
                                })),
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
