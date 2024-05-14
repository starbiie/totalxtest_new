import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Controller/providers/userProvider.dart';
import '../Model/usermodel.dart';
import '../View/widget/bottom_sheet.dart';
import '../View/widget/show_alert_box.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

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
      body: const UserListBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ShowAlertBox(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class UserListBody extends StatefulWidget {
  const UserListBody({Key? key}) : super(key: key);

  @override
  _UserListBodyState createState() => _UserListBodyState();
}

class _UserListBodyState extends State<UserListBody> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context, listen: false).fetchInitialUsers();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
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
                            onChanged: userProvider.runFilter,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: HexColor("000000")),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: HexColor("000000")),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                            backgroundColor: MaterialStateProperty.all(HexColor("100E09")),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () => modalBottomSheet(context, userProvider.isOlder, userProvider.sortUsers),
                          icon: const Icon(Icons.filter_list, color: Colors.white, size: 21),
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
                  if (!userProvider.isLoading && userProvider.hasMoreData && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    userProvider.fetchMoreUsers(); // Load more data
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: userProvider.foundUsers.length + (userProvider.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= userProvider.foundUsers.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    Map<String, dynamic>? userData = userProvider.foundUsers[index]; // Make userData nullable
                    if (userData != null) {
                      UserModel user = UserModel.fromMap(userData);
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(user.name ?? 'name'),
                          subtitle: Text('Age: ${user.age ?? 'age'}'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl ?? 'image'),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink(); // Return an empty widget if userData is null
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
