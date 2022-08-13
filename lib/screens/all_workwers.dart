import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workos/widgets/drawer_widget.dart';

import '../widgets/all_workers_widget .dart';

class AllWorkers extends StatelessWidget {
  const AllWorkers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text('All Workers'),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return AllworkersWidget(
                        userUid: snapshot.data!.docs[index]['id'],
                        position: snapshot.data!.docs[index]['position'],
                        name: snapshot.data!.docs[index]['name'],
                        phone: snapshot.data!.docs[index]['phone'],
                        imageUrl: snapshot.data!.docs[index]['image'],
                      );
                    });
              } else {
                return const Center(
                  child: Text('No data Found'),
                );
              }
            } else {
              return const Center(
                child: Text('No data Found'),
              );
            }
          },
        ));
  }
}
