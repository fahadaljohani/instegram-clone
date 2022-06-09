import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instegram_clone/Model/user.dart' as model;
import 'package:instegram_clone/resources/storage_methods.dart';

class AuthMethods {
  // - properties
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // - Methods
  Future<String> createUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List profilephoto,
  }) async {
    String res = 'Some error occur';
    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        bio.isNotEmpty &&
        profilephoto.isNotEmpty) {
      try {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadUrl = await StorageMethods()
            .uploadImageToStorage(file: profilephoto, childName: 'userProfile');
        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          password: password,
          bio: bio,
          photoUrl: downloadUrl,
          following: [],
          followers: [],
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJason());
        res = 'success';
      } on FirebaseException catch (e) {
        if (e.code == 'invalid-email') {
          print('الايميل غير صحيح');
        }
        return e.message.toString();
      }
    } else {
      return 'fill up all fields';
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String result = "Some error occur";
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = "success";
      } on FirebaseException catch (e) {
        result = e.message.toString();
      } catch (e) {
        result = e.toString();
      }
    } else {
      result = "fill up all fields";
    }
    return result;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
