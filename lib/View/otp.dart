import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:totalx_test/Controller/backend_servies.dart';
import 'package:totalx_test/View/userlist.dart';

class OtpScreen extends StatefulWidget {
  final String verificationid;
  final String mobilenumber;
  OtpScreen({
    super.key,
    required this.verificationid,
    required this.mobilenumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formState = GlobalKey<FormState>();

  late Timer _timer;

  int _seconds = 59;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void resendOtp() {
    setState(() {
      _seconds = 59;
      startTimer();
    });
  }

  String text = '';

  final otp = TextEditingController();

  BackendServices backendServices = BackendServices();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Image.asset("asset/images/verification.png"),
                ),
                SizedBox(height: screenHeight * 0.04),
                const Text(
                  "OTP Verification",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Enter the verification code we just sent to your\n number +91 *******21.",
                ),
                SizedBox(height: screenHeight * 0.04),
                Align(
                  alignment: Alignment.center,
                  child: Pinput(
                    focusedPinTheme: PinTheme(
                      width: 41,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(7)),
                    ),
                    controller: otp,
                    length: 6,
                    cursor: const Icon(Icons.linear_scale),
                    defaultPinTheme: PinTheme(
                      width: 41,
                      height: 40,
                      textStyle: TextStyle(
                          fontSize: 20,
                          color: HexColor("#FF5454"),
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        border: Border.all(color: HexColor("#100E09")),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Align(
                  alignment: Alignment.center,
                  child: Text("${_seconds.toString().padLeft(2, '0')} Sec",style: TextStyle(color: Colors.red
                  ),),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text("Don't Get OTP? "),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserList(),
                            ));
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(color: HexColor("2873F0")),
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserList(),
                          ));

                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationid,
                              smsCode: otp.text);

                      // Sign the user in (or link) with the credential
                      await backendServices.firebaseAuth
                          .signInWithCredential(credential);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("100E09"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        45,
                      ),
                    ),
                    child: const Text(
                      "Verify",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
