import 'package:chatapp/views/about/about.dart';
import 'package:chatapp/views/home/home.dart';
import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeVM>(builder: (vm) {
      return Drawer(
        child: Container(
          padding: EdgeInsets.zero,
          color: Theme.of(context).scaffoldBackgroundColor,
          // color: Colors.red,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: Get.height - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DrawerHeader(
                          padding: EdgeInsets.zero,
                          child: UserAccountsDrawerHeader(
                            // onDetailsPressed: (() => Get.to(() => FifthPage())),
                            arrowColor: Colors.black87,
                            decoration: BoxDecoration(
                                // color: Color.fromARGB(255, 34, 58, 99),
                                // color: Theme.of(context).backgroundColor,
                                ),
                            margin: EdgeInsets.zero,
                            accountEmail: Text("vikramnegi@gmail.com",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            accountName: Text("vikramnegi",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            currentAccountPicture: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network("https://picsum.photos/200",
                                  fit: BoxFit.cover),
                              // Image.memory(
                              //   Uint8List.fromList(
                              //       vm.currentUserData["image"]!.codeUnits),
                              //   width: 150,
                              //   fit: BoxFit.cover,
                              //   height: 150,
                              // ),
                            ),
                          ),
                        ),
                        DrawerItems(
                            iconData: Icons.home,
                            title: 'Home',
                            onTapFunc: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomePage()))),
                        DrawerItems(
                          iconData: Icons.add,
                          title: 'Add Book',
                          // onTapFunc: () => Navigator.of(context)
                          //     .pushReplacement(MaterialPageRoute(
                          //         builder: (context) => AddBook()))
                        ),
                        DrawerItems(
                          iconData: Icons.info_outline_rounded,
                          title: 'About US',
                          onTapFunc: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => AboutUsScreen())),
                        ),
                        DrawerItems(
                          iconData: CupertinoIcons.profile_circled,
                          title: 'Profile',
                          onTapFunc: () {
                            // Navigator.of(context)
                            //   .pushReplacement(MaterialPageRoute(
                            //       builder: (context) => FifthPage()))
                          },
                        ),
                        DrawerItems(
                          iconData: CupertinoIcons.settings_solid,
                          title: 'Setting',
                          onTapFunc: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SettingScreen()));
                          },
                        ),
                        const Divider(height: 5, color: Colors.grey),
                        DrawerItems(
                          iconData: CupertinoIcons.lock,
                          title: 'logout',
                          onTapFunc: () {
                            // CupertinoDialogBox(context, () {
                            //   Navigator.pop(context);
                            //   vm.logout();
                            //   Navigator.of(context).pushReplacement(
                            //       MaterialPageRoute(
                            //           builder: (context) => HomePage()));
                            // }, "Logout", 'Are you sure you want to logout?');
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('version 2.0.0',
                          style: TextStyle(color: Colors.grey.shade500)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class DrawerItems extends StatelessWidget {
  const DrawerItems({
    Key? key,
    required this.title,
    required this.iconData,
    this.onTapFunc,
  }) : super(key: key);
  final String title;
  final IconData iconData;
  final Function? onTapFunc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTapFunc != null) {
          onTapFunc!();
        }
      },
      child: ListTile(
        leading: Icon(
          iconData,
          color: (title == "logout")
              ? Colors.red
              : Theme.of(context).textTheme.bodyText1!.color,
        ),
        title: Text(
          title,
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: (title == "logout")
                ? Colors.red
                : Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
      ),
    );
  }
}
