import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/utils.dart';
import '../screens/profile_page.dart';

class AllworkersWidget extends StatefulWidget {
  final String userUid;
  final String position;
  final String name;
  final String phone;
  final String imageUrl;

  const AllworkersWidget({
    super.key,
    required this.userUid,
    required this.position,
    required this.name,
    required this.phone,
    required this.imageUrl,
  });
  @override
  State<AllworkersWidget> createState() => _AllworkersWidgetState();
}

class _AllworkersWidgetState extends State<AllworkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        onTap: () {
            FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final userUid = user!.uid;

               // String userUid = FirebaseAuth.instance.currentUser!.uid;
                navigateToPage(
                    context,
                    ProfilePage(
                      userUid: widget.userUid,
                    ));
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

            radius: 25,
            // https://image.flaticon.com/icons/png/128/850/850960.png
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          widget.name,
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
              '${widget.position} Tel: ${widget.phone}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.mail,
            size: 30,
            color: Colors.pink[800],
          ),
          onPressed: () {
            sendEmailMessage();
          },
        ),
      ),
    );
  }

  void sendEmailMessage() async {
    final url = Uri.parse('mailto:$widget. email');

    await launchUrl(
      url,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    ).then((value) {
      print(value);
    }).catchError((e) {
      print(e.toString());
    });
  }
   
}
