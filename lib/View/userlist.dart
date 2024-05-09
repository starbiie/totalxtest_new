import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:totalx_test/View/widget/bottom_sheet.dart';
import 'package:totalx_test/View/widget/show_alert_box.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  List<DocumentSnapshot> userDocs = [];
  DocumentSnapshot? lastDocument;
  final int perPage = 10;
  bool hasMoreData = true;
  bool isLoading = false;

  late List<Map<String, dynamic>> allUsers = [];
  late List<Map<String, dynamic>> foundUsers = [];
  bool? isOlder;

  @override
  void initState() {
    super.initState();
    fetchInitialUsers();
  }

  void fetchInitialUsers() async {
    if (!hasMoreData || isLoading) return;
    setState(() => isLoading = true);
    Query query = usersCollection.orderBy('name').limit(perPage);

    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      setState(() {
        hasMoreData = false;
        isLoading = false;
      });
    } else {
      setState(() {
        lastDocument = snapshot.docs.last;
        userDocs.addAll(snapshot.docs);
        allUsers.addAll(snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
        foundUsers = List.from(allUsers);
        isLoading = false;
      });
    }
  }

  void fetchMoreUsers() async {
    if (!hasMoreData || isLoading) return;
    setState(() => isLoading = true);

    Query query = usersCollection.orderBy('name').startAfterDocument(lastDocument!).limit(perPage);

    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      setState(() => hasMoreData = false);
    } else {
      setState(() {
        lastDocument = snapshot.docs.last;
        userDocs.addAll(snapshot.docs);
        allUsers.addAll(snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
        foundUsers = List.from(allUsers);
      });
    }
    setState(() => isLoading = false);
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
          user["name"].toString().toLowerCase().contains(
              enteredKeyword.toLowerCase())).toList();
    });
  }

  void _sortUsers(bool? isOlder) {
    setState(() {
      this.isOlder = isOlder;
      if (isOlder == null) {
        foundUsers = List.from(allUsers);
      } else if (isOlder) {
        foundUsers = allUsers.where((user) => int.parse(user['age'].toString()) >= 60).toList();
        foundUsers.sort((a, b) => int.parse(b['age'].toString()).compareTo(int.parse(a['age'].toString())));
      } else {
        foundUsers = allUsers.where((user) => int.parse(user['age'].toString()) < 60).toList();
        foundUsers.sort((a, b) => int.parse(a['age'].toString()).compareTo(int.parse(b['age'].toString())));
      }
    });
  }


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
              size: MediaQuery
                  .of(context)
                  .size
                  .width * 0.06,
            ),
            SizedBox(width: MediaQuery
                .of(context)
                .size
                .width * 0.01),
            Expanded(
              child: Text(
                "Nilambur",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery
                      .of(context)
                      .size
                      .width * 0.045,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20)),
                              borderSide: BorderSide(color: HexColor("000000")),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20)),
                              borderSide: BorderSide(color: HexColor("000000")),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20)),
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
                      constraints: const BoxConstraints(maxWidth: 50),
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(HexColor(
                              "100E09")),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        onPressed: () =>
                            modalBottomSheet(
                                context, isOlder, _sortUsers),
                        icon: const Icon(
                            Icons.filter_list, color: Colors.white, size: 21),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text("Users Lists", style: TextStyle(fontSize: 15)),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && hasMoreData && scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  fetchMoreUsers(); // Load more data
                }
                return true;
              },
              child: ListView.builder(
                itemCount: foundUsers.length + (hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= foundUsers.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  Map<String, dynamic> user = foundUsers[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(user['name']),
                      subtitle: Text('Age: ${user['age']}'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['image']),
                      ),
                    ),
                  );
                },
              ),

            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () =>
            showDialog(
              context: context,
              builder: (context) => ShowAlertBox(),
            ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}