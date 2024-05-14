import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Controller/providers/userProvider.dart';
import '../../Model/usermodel.dart';

class ShowAlertBox extends StatelessWidget {
  ShowAlertBox({super.key});

  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add A New User",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: userProvider.image == null
                  ? Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: 70,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("asset/images/user (10) 1.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 65,
                    left: 8,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Container(
                            height: 30,
                            width: 120,
                            color: Colors.transparent,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Opacity(
                              opacity: 0.8,
                              child: InkWell(
                                onTap: () {
                                  userProvider.pickImage(ImageSource.gallery);
                                },
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  height: 84,
                                  width: 84,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  : Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: height * 0.10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(userProvider.image!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 65,
                    left: 8,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Container(
                            height: 30,
                            width: 120,
                            color: Colors.transparent,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Opacity(
                              opacity: 0.8,
                              child: InkWell(
                                onTap: () {
                                  userProvider.pickImage(ImageSource.gallery);
                                },
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  height: 84,
                                  width: 84,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Name", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            TextField(
              controller: name,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                isDense: true,
                filled: true,
                fillColor: HexColor("FDFDFD"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor("D3D3D3")),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor("D3D3D3")),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Age", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            TextField(
              controller: age,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                isDense: true,
                filled: true,
                fillColor: HexColor("FDFDFD"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor("D3D3D3")),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor("D3D3D3")),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (name.text.isNotEmpty && age.text.isNotEmpty && userProvider.image != null) {
                String imageUrl = await userProvider.uploadImage(userProvider.image!);
                UserModel userModel = UserModel(
                  userid: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name.text,
                  age: age.text,
                  imageUrl: imageUrl,
                );
                userProvider.addUser(userModel);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
