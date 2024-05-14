//backend_servieses.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:totalx_test/View/userlist.dart';

import '../View/otp.dart';

class BackendServices{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<void> initiatePhoneVerification(BuildContext context,phoneController) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '$selectedcountrycode${phoneController.text}',
        verificationCompleted: (PhoneAuthCredential credential) {
          signInWithPhoneCredential(context, credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.message}'),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                    verificationid: verificationId,
                    mobilenumber:
                    '$selectedcountrycode${phoneController.text}')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> signInWithPhoneCredential(
      BuildContext context, PhoneAuthCredential credential) async {
    try {
      final authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (authResult.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserList(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  final selectedcountrycode = '+91';


}