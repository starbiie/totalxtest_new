import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:totalx_test/Controller/backend_servies.dart';
// import 'package:pinput/pinput.dart';
import 'package:totalx_test/View/userlist.dart';

class OtpScreen extends StatelessWidget {
  final String verificationid;
  final String mobilenumber;
  OtpScreen({
    super.key,
    required this.verificationid,
    required this.mobilenumber,
  });
  final _formState = GlobalKey<FormState>();


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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text("Don't Get OTP? "),
                    InkWell(   onTap: (){                   Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserList(),));},
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
                    onPressed: () async{
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserList(),));

                      PhoneAuthCredential credential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationid,
                          smsCode: otp.text);

                      // Sign the user in (or link) with the credential
                      await backendServices.firebaseAuth.signInWithCredential(credential);
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
