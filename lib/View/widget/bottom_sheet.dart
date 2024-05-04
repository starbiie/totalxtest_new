import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/providers/userProvider.dart';

void settingModalBottomSheet(
    BuildContext context, bool? isOlder, Function(bool?) sortUsers) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Consumer<UserProvider>(
        builder: (context, provider, _) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 10),
                  child: Text(
                    "Sort",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                ListTile(
                  leading: Radio(
                    value: null,
                    groupValue: isOlder,
                    onChanged: (value) {
                      sortUsers(value as bool?);
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text("All"),
                ),
                ListTile(
                  leading: Radio(
                    value: true,
                    groupValue: isOlder,
                    onChanged: (value) {
                      sortUsers(value as bool?);
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text("Age: Older"),
                ),
                ListTile(
                  leading: Radio(
                    value: false,
                    groupValue: isOlder,
                    onChanged: (value) {
                      sortUsers(value as bool?);
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text("Age: Younger"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}