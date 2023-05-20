import 'package:chatapp/views/chat_view/user_Chat_page.dart';
import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  HomeVM vm =
      Get.isRegistered<HomeVM>() ? Get.find<HomeVM>() : Get.put(HomeVM());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeVM>(builder: (vm) {
      return Scaffold(
          appBar: AppBar(
            leadingWidth: 35,
            leading: InkWell(
              onTap: () {
                vm.searchList.clear();
                Get.back();
              },
              child: const Icon(Icons.arrow_back),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () {
                    vm.getSearchedUsers();
                  },
                  child: const Icon(Icons.search),
                ),
              ),
            ],
            titleSpacing: 0,
            title: TextFormField(
              controller: vm.searchController,
              decoration: InputDecoration(
                hintText: "Type here to search",
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 15, right: 5),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(color: Colors.white)),
                filled: true,
                fillColor: Colors.grey.shade300,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.white)),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    vm.searchController.clear();
                  },
                ),
              ),
            ),
          ),
          body: vm.searchLoading
              ? SizedBox(
                  height: Get.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, i) {
                    return Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: i == 0 ? 15 : 0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  NetworkImage(vm.searchList[i].profileImage!),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  vm.searchList[i].name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "@${vm.searchList[i].username}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            const Spacer(),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade600,
                              child: IconButton(
                                  onPressed: () {
                                    Get.to(
                                        UserChatPage(
                                          isWeb: (MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  700)
                                              ? true
                                              : false,
                                          profileImage:
                                              vm.searchList[i].profileImage!,
                                          receiverId: vm.searchList[i].id,
                                          receiverName: vm.searchList[i].name,
                                        ),
                                        arguments: {
                                          "receiverUserId": vm.searchList[i].id,
                                        },
                                        transition: Transition.rightToLeft);
                                  },
                                  icon: Icon(Icons.message)),
                            )
                          ],
                        ));
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(height: 10);
                  },
                  itemCount: vm.searchList.length));
    });
  }
}
