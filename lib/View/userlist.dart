import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../Controller/providers/userProvider.dart';
import 'package:totalx_test/View/widget/bottom_sheet.dart';
import 'package:totalx_test/View/widget/show_alert_box.dart';

class UserList extends StatefulWidget {
  UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  late List<Map<String, dynamic>> allUsers = [];
  late List<Map<String, dynamic>> foundUsers = [];
  bool? isOlder;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final snapshot = await usersCollection.get();
    setState(() {
      allUsers = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      foundUsers = List.from(allUsers);
    });
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        foundUsers = List.from(allUsers);
      });
      return;
    }
    setState(() {
      foundUsers = allUsers.where((user) =>
          user["name"].toString().toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    });
  }

  void _sortUsers(bool? isOlder) {
    setState(() {
      if (isOlder == null) {
        foundUsers = List.from(allUsers);
      } else {
        this.isOlder = isOlder;
        foundUsers.sort((a, b) {
          final ageA = int.parse(a['age'].toString());
          final ageB = int.parse(b['age'].toString());
          if (isOlder) {
            return ageB.compareTo(ageA);
          } else {
            return ageA.compareTo(ageB);
          }
        });
      }
    });
  }
// void _sortUsers(bool isOlder) {
  //   setState(() {
  //     this.isOlder = isOlder;
  //     foundUsers.sort((a, b) {
  //       final ageA = int.parse(a['age'].toString());
  //       final ageB = int.parse(b['age'].toString());
  //       if (isOlder) {
  //         return ageB.compareTo(59);
  //       } else {
  //         return ageA.compareTo(60);
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("EBEBEB"),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Expanded(
              child: Text(
                "Nilambur",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Form(
                      child: TextFormField(
                        // controller: _searchController,
                        onChanged: _runFilter,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: HexColor("000000")),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: HexColor("000000")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: HexColor("000000")),
                          ),
                          hintText: "Search now...",
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 50,
                    ),
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(HexColor("100E09")),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        settingModalBottomSheet(
                            context, isOlder, _sortUsers);
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Users Lists",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 5,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: usersCollection.snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundUsers.length,
                    itemBuilder: (context, index) {
                      final user = foundUsers[index];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(user['name']),
                          subtitle: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Age: ',
                                ),
                                TextSpan(
                                  text: user['age'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user['image'],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ShowAlertBox();
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
