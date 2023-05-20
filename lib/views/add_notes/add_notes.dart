import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNotes extends StatelessWidget {
  AddNotes({super.key});
  HomeVM vm =
      Get.isRegistered<HomeVM>() ? Get.find<HomeVM>() : Get.put(HomeVM());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeVM>(builder: (vm) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.grey.shade800,
            elevation: 0,
            title: const Text("Add Notes"),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.folder, color: Colors.grey.shade800),
                          SizedBox(width: 3),
                          Text("Uncategorised"),
                        ],
                      )),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: vm.notesController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${DateTime.now().toString().substring(0, 10)}    ${vm.convertDateTime(DateTime.now())}  |  ${vm.notesController.text.length} characters",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLines: 100,
                      keyboardType: TextInputType.multiline,
                      controller: vm.notesController,
                      decoration: const InputDecoration(
                        hintText: "Start typing...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              )));
    });
  }
}
