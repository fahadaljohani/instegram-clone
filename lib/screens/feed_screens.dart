import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instegram_clone/screens/login_screen.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/wedgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.messenger_outline),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
          );
        },
      ),
    );
  }
}
