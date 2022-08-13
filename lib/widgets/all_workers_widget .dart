import 'package:flutter/material.dart';

class AllworkersWidget extends StatefulWidget {
  const AllworkersWidget({Key? key}) : super(key: key);

  @override
  State<AllworkersWidget> createState() => _AllworkersWidgetState();
}

class _AllworkersWidgetState extends State<AllworkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        onTap: () {},
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

            radius: 25,
            // https://image.flaticon.com/icons/png/128/850/850960.png
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://heavy.com/wp-content/uploads/2016/05/gettyimages-2123365.jpg?quality=65&strip=all',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: const Text(
          'Name',
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
              'Position in the company / 01123627733',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.mail,
          size: 30,
          color: Colors.pink[800],
        ),
      ),
    );
  }
}
