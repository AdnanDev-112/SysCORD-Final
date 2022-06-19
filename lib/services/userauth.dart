import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sysbin/providers/userroleprov.dart';
import 'package:flutter/material.dart';

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(
    User user,
  ) async {
    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
    };
    final userRef = _db.collection("usersLogin").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
        "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
      });
    } else {
      await _db.collection("usersLogin").doc(user.uid).set(userData);
    }
  }

  updateProvider(User user, BuildContext context) async {
    final userRef = _db.collection("usersLogin").doc(user.uid);

    userRef.get().then((DocumentSnapshot<Map<String, dynamic>> docSnap) {
      var docData = docSnap.data();
      var userRole = docData!['role'];
      Provider.of<UserRoleProvider>(context, listen: false)
          .setRole(userRole == "user" ? false : true);
    });
  }
}
