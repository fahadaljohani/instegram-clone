import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  // - properties
  final String username;
  final String postId;
  final String description;
  final String uid;
  final String profileUrl;
  final String photoUrl;
  final uploadDate;
  final List likes;
  Post({
    required this.username,
    required this.postId,
    required this.description,
    required this.uid,
    required this.profileUrl,
    required this.photoUrl,
    required this.uploadDate,
    required this.likes,
  });

  // - Methods
  Map<String, dynamic> toJason() {
    return {
      'username': username,
      'description': description,
      'uid': uid,
      'profileUrl': profileUrl,
      'photoUrl': photoUrl,
      'uploadDate': uploadDate,
      'likes': likes,
      'postId': postId
    };
  }

  static Post fromSnap(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      postId: snap['postId'],
      username: snap['username'],
      description: snap['description'],
      uid: snap['uid'],
      profileUrl: snap['profileUrl'],
      photoUrl: snap['photoUrl'],
      uploadDate: snap['uploadDate'],
      likes: snap['likes'],
    );
  }
}
