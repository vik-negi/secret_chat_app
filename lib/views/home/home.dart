import 'package:chatapp/main.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/widgets/PopUpMenuBtn.dart';
import 'package:chatapp/utils/widgets/drawer.dart';
import 'package:chatapp/views/add_notes/add_notes.dart';
import 'package:chatapp/views/chat_view/chart.dart';
import 'package:chatapp/views/chat_view/chart_view_home.dart';
import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  HomeVM vm = Get.put(HomeVM());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GetBuilder<HomeVM>(builder: (vm) {
        return
            // vm.isUserAuthenticated
            //     ?
            Scaffold(
          drawer: const MyDrawer(),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  // backgroundColor: AppColors.whiteColor,
                  // foregroundColor: Colors.black,
                  elevation: 0,
                  title: const Text(
                    'Notes',
                    style: TextStyle(
                      // color: AppColors.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [
                    InkWell(
                        onLongPress: () {
                          if (vm.isUserAuthenticated) {
                            Get.to(() => ChatHomeView());
                          } else {
                            Get.toNamed('signin');
                          }
                        },
                        child: Icon(Icons.chat_bubble,
                            color: Theme.of(context).primaryColor))
                  ],
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: PreferredSize(
                    // preferredSize : const Size.fromHeight(124),
                    preferredSize: const Size.fromHeight(105),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () {
                                // vm.userTapForSearch();
                                // Get.to(() => SearchPage());
                              },
                              child: SearchBar()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250,
                                child: TabBar(
                                    indicatorSize: TabBarIndicatorSize.label,
                                    controller: vm.tabController,
                                    tabs: vm.myTabs),
                              ),
                              Icon(
                                Icons.window_sharp,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // ),
              ];
            },
            body: TabBarView(
                controller: vm.tabController,
                children: const [Notes(), Notes()]),
            // body:
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // bottomModelWidget(context);
              Get.to(() => AddNotes());
            },
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeVM>(builder: (vm) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: const Text(
                  "Featured Notes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Container(
              height: 250,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 220,
                          width: 150,
                          decoration: BoxDecoration(
                            color: vm.color[i],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            width: 150,
                            height: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(200),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 200,
                          width: 150,
                          child: Center(
                            child: Column(
                              children: const [
                                Text("Notes of the day"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: 5),
            ),
            SizedBox(
              height: 10 * 90,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Diner at 8:00 PM",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 10),
                              Text(
                                  "Today we have a meeting with Mr. John regarding the new project.",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade500)),
                              const SizedBox(height: 8),
                              Text("26 August 2023",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey.shade800))
                            ],
                          )));
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SearchBar extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10),

      height: 55,
      // color: AppColors.whiteColor,
      child: Card(
        color: Colors.grey.shade200,
        elevation: 0,
        shape: RoundedRectangleBorder(
            // side: BorderSide(
            // ),
            borderRadius: BorderRadius.circular(15)),
        // color: AppColors.whiteColor,
        child: const ListTile(
          dense: true,
          leading: Icon(
            Icons.search,
            // color: Theme.og,
          ),
          title: Text("Search here...", style: TextStyle(fontSize: 18)),
          // TextField(
          //   readOnly: true,
          //   controller: controller,
          //   decoration: const InputDecoration(
          //       hintStyle: TextStyle(color: Colors.black),
          //       // labelText: ,
          //       hintText: "Search here...",
          //       border: InputBorder.none),
          // ),
          trailing: Icon(Icons.mic),
        ),
      ),
    );
  }
}
