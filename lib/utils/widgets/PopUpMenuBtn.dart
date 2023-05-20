import "package:chatapp/utils/sharedPreferenced.dart";
import "package:chatapp/utils/widgets/login_first_dialogbox.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class PopupMenuBtn extends StatelessWidget {
  const PopupMenuBtn({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(onSelected: (value) {
      print(value);
    }, itemBuilder: (context) {
      return [
        for (var i = 0; i < items.length; i++)
          popMenuItm(context, items[i], i.toString()),
      ];
    });
  }

  PopupMenuItem<String> popMenuItm(context, String name, String value) {
    return PopupMenuItem(
      onTap: () async {
        print("login clicked $name");
        if (name == "logout") {
          showDialogBox(
              context, "Logout", "Are you sure you want to logout?", true);
        }
      },
      value: value,
      child: Text(name),
    );
  }
}
