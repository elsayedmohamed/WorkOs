import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workos/constants.dart';

import '../user_state.dart';
import '../widgets/drawer_widget.dart';

class ProfilePage extends StatefulWidget {
  final String userUid;
  const ProfilePage({required this.userUid});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

String name = '';
String email = '';
String phoneNumber = '';
String position = '';
String joindate = '';
String? image;
String? urlImage =
    'https://www.seekpng.com/png/full/110-1100707_person-avatar-placeholder.png';
bool isTheSameUser = false;
bool isLoading = false;

class _ProfilePageState extends State<ProfilePage> {
  // String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    getUserDataFromFireBase();
    setState(() {});
    super.initState();
  }

  void getUserDataFromFireBase() async {
    try {
      isLoading = true;
      final DocumentSnapshot userDocData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userUid)
          .get();

      if (userDocData == null) {
        return;
      } else {
        name = userDocData.get('name');
        email = userDocData.get('email');
        phoneNumber = userDocData.get('phone');
        position = userDocData.get('position');
        Timestamp createdAt = userDocData.get('date');
        var date = createdAt.toDate();
        joindate = '${date.year}-${date.month}-${date.day}';
        image = userDocData.get('image');
      }

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String uid = user!.uid;
      print('User Uid=${widget.userUid}');
      setState(() {
        isTheSameUser = uid == widget.userUid;
        print('isTheSameUser $isTheSameUser');
      });
    } on Exception catch (e) {
      isLoading = false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: AppConstants.kDarkBlue,
        ),
        primary: true,
        //foregroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading? Center(
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
            ):Stack(children: [
        SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.kDarkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '$position since:$joindate',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Contact info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.kDarkBlue,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ContactsInfo(titleText: 'Email', infoText: email),
                  ContactsInfo(
                      titleText: 'Phone number', infoText: phoneNumber),
                  const SizedBox(
                    height: 20,
                  ),
                  isTheSameUser
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                              SocialMediaBottons(
                                  color: Colors.red,
                                  onPressed: () {
                                    sendWhatsAppMessage();
                                  },
                                  icon: Icons.whatsapp,
                                  socialIconColor: Colors.green),
                              SocialMediaBottons(
                                  color: Colors.red,
                                  onPressed: () {
                                    sendEmailMessage();
                                  },
                                  icon: Icons.message,
                                  socialIconColor: Colors.red),
                              SocialMediaBottons(
                                  color: Colors.red,
                                  onPressed: () {
                                    makePhoneCall();
                                  },
                                  icon: Icons.call,
                                  socialIconColor: Colors.purple),
                            ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 150,
                      child: MaterialButton(
                        height: 55,
                        color: Colors.pink.shade600,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          final FirebaseAuth auth = FirebaseAuth.instance;

                          auth.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const UserStateScreen())),
                              (route) => false);
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 20,
          left: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.width * 0.2,
                width: size.width * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(150),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${image ?? urlImage}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

void makePhoneCall() async {
  final url = Uri.parse('tel:$phoneNumber');

  await launchUrl(
    url,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  ).then((value) {
    print(value);
  }).catchError((e) {
    print(e.toString());
  });
}

void sendEmailMessage() async {
  final url = Uri.parse('mailto:$email');

  await launchUrl(
    url,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  ).then((value) {
    print(value);
  }).catchError((e) {
    print(e.toString());
  });
}

void sendWhatsAppMessage() async {
  final url = Uri.parse('https://wa.me/$phoneNumber');
  await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  ).then((value) {
    print(value);
  }).catchError((e) {
    print(e.toString());
  });
}

class ContactsInfo extends StatelessWidget {
  const ContactsInfo({
    Key? key,
    required this.titleText,
    required this.infoText,
  }) : super(key: key);
  final String titleText;
  final String infoText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$titleText :',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.kDarkBlue,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Text(
          infoText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConstants.kDarkBlue,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class SocialMediaBottons extends StatelessWidget {
  const SocialMediaBottons({
    required this.color,
    required this.onPressed,
    required this.icon,
    required this.socialIconColor,
    Key? key,
  }) : super(key: key);
  final Color color;
  final void Function()? onPressed;
  final IconData icon;
  final Color socialIconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: socialIconColor,
          ),
        ),
      ),
    );
  }
}
