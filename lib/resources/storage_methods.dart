import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      {required Uint8List file,
      required String childName,
      bool isPost = false}) async {
    final uKey = const Uuid().v1();
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      ref = ref.child(uKey);
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
