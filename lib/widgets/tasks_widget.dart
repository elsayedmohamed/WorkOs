import 'package:flutter/material.dart';

import '../inner_screens/task_details.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

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
      navigateToPage(context, TaskDetailScreen()) ;   
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10,),
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
                'https://vignette.wikia.nocookie.net/scream-queens/images/d/d6/Right.png/revision/latest?cb=20151213161824'),
          ),
        ),
        title: const Text(
          'title',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
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
            const Text(
              'Subtitle  description ',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
 Future<Object?> navigateToPage(BuildContext context, Widget screen) async {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }
