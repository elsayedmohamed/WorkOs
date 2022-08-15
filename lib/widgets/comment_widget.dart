import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/utils.dart';
import '../screens/profile_page.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({
 
    required this.commentId,
    required this.commentBody,
    required this.commentImagrUrl,
    required this.commenterName,
    required this.commenterId,
  });
  final String commentId;
  final String commentBody;
  final String commentImagrUrl;
  final String commenterName;
  final String commenterId;

  final List<Color> _colors = [
    Colors.red,
    Colors.amber,
    Colors.black,
    Colors.purple,
    Colors.pink,
    Colors.orange,
  ];
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: (() {
            FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final userUid = user!.uid;

               // String userUid = FirebaseAuth.instance.currentUser!.uid;
                navigateToPage(
                    context,
                    ProfilePage(
                      userUid: userUid,
                    ));
      }),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: _colors[0],
                ),
                image: DecorationImage(
                  image: NetworkImage(commentImagrUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(commenterName),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    commentBody,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
