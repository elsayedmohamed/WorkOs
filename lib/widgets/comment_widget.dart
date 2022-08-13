import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
   CommentWidget({Key? key}) : super(key: key);

  List<Color> _colors = [
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
    return Row(
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
                color:_colors[0],
              ),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80'),
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
                const Text('Commenter Name'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'comment Text ',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
