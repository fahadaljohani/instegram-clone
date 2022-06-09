import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instegram_clone/Model/post.dart';
import 'package:instegram_clone/Model/user.dart' as Model;
import 'package:instegram_clone/resources/auth_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Model.User> getUserDetails() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return Model.User.fromSnap(snapshot);
  }

  Future<String> postImage(String uid, String description, String username,
      String profileUrl, String postUrl) async {
    String postId = const Uuid().v1();
    String result = "Some error occurred";
    try {
      Post post = Post(
          username: username,
          description: description,
          uid: uid,
          profileUrl: profileUrl,
          photoUrl: postUrl,
          uploadDate: DateTime.now(),
          likes: [],
          postId: postId);
      await _firestore.collection('posts').doc(postId).set(post.toJason());
      result = "success";
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<void> likeImage(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addComment(String postID, String text, String uid,
      String username, String profileUrl) async {
    if (postID.isEmpty ||
        text.isEmpty ||
        uid.isEmpty ||
        username.isEmpty ||
        profileUrl.isEmpty) return;

    String docID = Uuid().v1();
    try {
      await _firestore
          .collection('posts')
          .doc(postID)
          .collection('comments')
          .doc(docID)
          .set({
        'postId': postID,
        'username': username,
        'text': text,
        'profileUrl': profileUrl,
        'publishedData': DateTime.now(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followID) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(followID).get();
      var snap = snapshot.data()! as dynamic;
      List followers = snap['followers'];
      if (followers.contains(uid)) {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID]),
        });
      } else {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
