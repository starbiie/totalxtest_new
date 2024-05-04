import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:totalx_test/Controller/backend_servies.dart';
import 'package:totalx_test/View/otp.dart';
import 'package:totalx_test/View/userlist.dart';

class Auth1 extends StatelessWidget {
  Auth1({super.key});

  final TextEditingController textController = TextEditingController();

  String text = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    BackendServices backendServices = BackendServices();
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
                  child: Image.asset("asset/images/OBJECTS.png"),
                ),
                SizedBox(height: screenHeight * 0.04),
                const Text(
                  "Enter Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: textController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: HexColor("000000").withOpacity(0.40),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: HexColor("000000").withOpacity(0.40),
                        ),
                      ),
                      hintText: "Enter Phone Number *",
                      hintStyle: TextStyle(
                        color: HexColor("000000").withOpacity(0.40),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'By Continuing, I agree to TotalX’s ',
                      ),
                      TextSpan(
                        text: 'Terms and condition',
                        style: TextStyle(
                          color: HexColor("2873F0"),
                        ),
                      ),
                      const TextSpan(
                        text: ' & ',
                      ),
                      TextSpan(
                        text: 'privacy policy',
                        style: TextStyle(
                          color: HexColor("2873F0"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                                verificationid: "yjuj7u",// fire base Otp issue //
                                mobilenumber: 7902210780.toString()),
                          ));


                      await backendServices.initiatePhoneVerification(
                          context, textController);
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
                      "Get OTP",
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
