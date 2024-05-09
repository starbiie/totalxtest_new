import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/providers/userProvider.dart';
void modalBottomSheet(
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
                  child: Text("Sort", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ),
                ListTile(
                  leading: Radio<bool?>(
                    value: null,
                    groupValue: isOlder,
                    onChanged: (bool? value) {
                      Navigator.pop(context);
                      sortUsers(value);
                    },
                  ),
                  title: const Text("All"),
                ),
                ListTile(
                  leading: Radio<bool?>(
                    value: true,
                    groupValue: isOlder,
                    onChanged: (bool? value) {
                      Navigator.pop(context);
                      sortUsers(value);
                    },
                  ),
                  title: const Text("Older"),
                ),
                ListTile(
                  leading: Radio<bool?>(
                    value: false,
                    groupValue: isOlder,
                    onChanged: (bool? value) {
                      Navigator.pop(context);
                      sortUsers(value);
                    },
                  ),
                  title: const Text("Younger"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
