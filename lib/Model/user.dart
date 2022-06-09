import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // - properties
  final String username;
  final String uid;
  final String email;
  final String password;
  final String bio;
  final String photoUrl;
  final List following;
  final List followers;

  User({
    required this.username,
    required this.uid,
    required this.email,
    required this.password,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  // - Methods
  Map<String, dynamic> toJason() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'password': password,
      'bio': bio,
      'profilePhoto': photoUrl,
      'followers': followers,
      'following': following,
    };
  }

  static User fromSnap(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;
    return User(
      username: snap['username'],
      uid: snap['uid'],
      email: snap['email'],
      password: snap['password'],
      bio: snap['bio'],
      photoUrl: snap['profilePhoto'],
      followers: snap['followers'],
      following: snap['following'],
    );
  }
}
