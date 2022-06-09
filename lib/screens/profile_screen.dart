import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/resources/auth_methods.dart';
import 'package:instegram_clone/resources/firestore_methods.dart';
import 'package:instegram_clone/screens/login_screen.dart';
import 'package:instegram_clone/utils/colors.dart';

import '../wedgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  int postlen = 0;
  var userData = {};

  int followers = 0;
  int following = 0;

  bool isFollowing = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    var usersnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    List followersList = usersnap.data()!['followers'];
    followers = followersList.length;
    following = (usersnap.data()! as dynamic)['following'].length;
    isFollowing =
        followersList.contains(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .get();
    postlen = posts.docs.length;
    setState(() {
      userData = usersnap.data()!;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    print(FirebaseAuth.instance.currentUser!.uid);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(userData['profilePhoto']),
                            radius: 40,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  userStatus(postlen, 'Posts'),
                                  userStatus(followers, 'followers'),
                                  userStatus(following, 'following'),
                                ],
                              ),
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? FollowButton(
                                      text: 'Sign Out',
                                      textColor: primaryColor,
                                      backgroundColor: mobileBackgroundColor,
                                      borderColor: Colors.grey,
                                      function: () async {
                                        await AuthMethods().signOut();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()));
                                      },
                                    )
                                  : isFollowing
                                      ? FollowButton(
                                          text: 'unfollow',
                                          textColor: mobileBackgroundColor,
                                          backgroundColor: primaryColor,
                                          borderColor: Colors.grey,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                widget.uid);
                                            setState(() {
                                              followers--;
                                              isFollowing = false;
                                            });
                                          })
                                      : FollowButton(
                                          text: 'follow',
                                          textColor: primaryColor,
                                          backgroundColor: blueColor,
                                          borderColor: Colors.blue,
                                          function: () async {
                                            await FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                widget.uid);
                                            setState(() {
                                              followers++;
                                              isFollowing = true;
                                            });
                                          }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Text(
                                userData['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                userData['bio'],
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 1.5,
                                mainAxisSpacing: 5,
                                crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return Image.network(
                            snapshot.data!.docs[index]['photoUrl'],
                            fit: BoxFit.cover,
                          );
                        });
                  },
                ),
              ],
            ),
          );
  }

  Column userStatus(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
