import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  String? ageFilter; // Added ageFilter variable

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  File? images;

  File? get image => images;

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      images = File(pickedImage.path);
    } else {
      images = null;
    }
    notifyListeners();
  }

  void setAgeFilter1(value) {
    ageFilter = value;
    notifyListeners();
  }

  void setAgeFilter2(value) {
    ageFilter = value;
    notifyListeners();
  }

  void setAgeFilter3(value) {
    ageFilter = value;
    notifyListeners();
  }


  // void search(String value) {
  //   List<Map<String, dynamic>> results = [];
  //   if (value.isEmpty) {
  //     foundUsers.clear();
  //     notifyListeners();
  //     return;
  //   }
  //   usersCollection.get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((document) {
  //       if (document['name']
  //           .toString()
  //           .toLowerCase()
  //           .contains(value.toString().toLowerCase())) {
  //         results.add(document.data() as Map<String, dynamic>);
  //       }
  //     });
  //     foundUsers = results;
  //     notifyListeners();
  //   });
  // }
  // void filterUsers(String value) {
  //   usersCollection.get().then((querySnapshot) {
  //     List<Map<String, dynamic>> results = [];
  //     querySnapshot.docs.forEach((document) {
  //       if (document['name']
  //           .toString()
  //           .toLowerCase()
  //           .contains(value.toLowerCase())) {
  //         results.add(document.data() as Map<String, dynamic>);
  //       }
  //     });
  //     foundUsers = results;
  //     notifyListeners();
  //   });
  // }
  //
  // List<Map<String, dynamic>> foundUsers = [];
}

