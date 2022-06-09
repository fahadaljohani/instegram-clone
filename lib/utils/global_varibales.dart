import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/screens/add_post_screen.dart';
import 'package:instegram_clone/screens/feed_screens.dart';
import 'package:instegram_clone/screens/profile_screen.dart';
import 'package:instegram_clone/screens/search_screen.dart';

const mobileWidth = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(child: Text('notification')),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
