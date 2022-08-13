import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workos/constants.dart';

import '../widgets/drawer_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      
      
      body: Stack(children: [
        Card(
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
                    'Mrak nat',
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
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Manager since 2021-07-14',
                    style: TextStyle(
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
                const ContactsInfo(
                    titleText: 'Email', infoText: 'elsayed201@gmail.com'),
                const ContactsInfo(
                    titleText: 'Phone number', infoText: '+201123627733'),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SocialMediaBottons(
                          color: Colors.red,
                          onPressed: () {},
                          icon: Icons.whatsapp,
                          socialIconColor: Colors.green),
                      SocialMediaBottons(
                          color: Colors.red,
                          onPressed: () {},
                          icon: Icons.message,
                          socialIconColor: Colors.red),
                      SocialMediaBottons(
                          color: Colors.red,
                          onPressed: () {},
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
                      onPressed: () {},
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
        Positioned(
          top: 0,
          right: 20,
          left: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.width*0.2,
                width:size.width*0.2,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(150),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://heavy.com/wp-content/uploads/2016/05/gettyimages-2123365.jpg?quality=65&strip=all',
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
