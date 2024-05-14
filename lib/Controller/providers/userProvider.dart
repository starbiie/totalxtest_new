import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../Model/usermodel.dart';

class UserProvider extends ChangeNotifier {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  List<DocumentSnapshot> userDocs = [];
  DocumentSnapshot? lastDocument;
  final int perPage = 10;
  bool hasMoreData = true;
  bool isLoading = false;

  late List<Map<String, dynamic>> allUsers = [];
  late List<Map<String, dynamic>> foundUsers = [];
  bool? isOlder;
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

  Future<String> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> addUser(UserModel userModel) async {
    await usersCollection.add(userModel.toMap());
    fetchInitialUsers();
  }

  void fetchInitialUsers() async {
    if (!hasMoreData || isLoading) return;
    isLoading = true;

    Query query = usersCollection.orderBy('name').limit(perPage);

    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      hasMoreData = false;
    } else {
      lastDocument = snapshot.docs.last;
      userDocs.addAll(snapshot.docs);
      allUsers.addAll(snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
      foundUsers = List.from(allUsers);
    }
    isLoading = false;
    notifyListeners();
  }

  void fetchMoreUsers() async {


    if (!hasMoreData || isLoading) return;
    isLoading = true;
    Query query = usersCollection.orderBy('name').startAfterDocument(lastDocument!).limit(perPage);

    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      hasMoreData = false;
    } else {
      lastDocument = snapshot.docs.last;
      userDocs.addAll(snapshot.docs);
      allUsers.addAll(snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
      foundUsers = List.from(allUsers);
    }
    isLoading = false;
    notifyListeners();
  }
  void updateUsers(List<UserModel> users) {
    allUsers = users.map((user) => user.toMap()).toList();
    foundUsers = allUsers;
    notifyListeners();
  }
  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      foundUsers = List.from(allUsers);
    } else {
      foundUsers = allUsers.where((user) => user["name"].toString().toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    notifyListeners();
  }

  void sortUsers(bool? isOlder) {
    this.isOlder = isOlder;
    if (isOlder == null) {
      foundUsers = List.from(allUsers);
    } else if (isOlder) {
      foundUsers = allUsers.where((user) => int.parse(user['age'].toString()) >= 60).toList();
      foundUsers.sort((a, b) => int.parse(b['age'].toString()).compareTo(int.parse(a['age'].toString())));
    } else {
      foundUsers = allUsers.where((user) => int.parse(user['age'].toString()) < 60).toList();
      foundUsers
          .sort((a, b) => int.parse(a['age'].toString()).compareTo(int.parse(b['age'].toString())));
    }
    notifyListeners();
  }
}
class OtpProvider extends ChangeNotifier {
  late Timer _timer;

  int secondses = 59;

  int get seconds => secondses;

  bool get timerActive => _timer.isActive;

  OtpProvider() {
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondses > 0) {
        secondses--;
        notifyListeners();
      } else {
        _timer.cancel();
      }
    });
  }

  void resendOtp() {
    secondses = 59;
    startTimer();
    notifyListeners();
  }
}

