import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instegram_clone/Model/user.dart';
import 'package:instegram_clone/resources/firestore_methods.dart';

class UserProvider with ChangeNotifier {
  late User _user;
  getUser() => _user;

  Future<void> refreshUser() async {
    final user = await FirestoreMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
