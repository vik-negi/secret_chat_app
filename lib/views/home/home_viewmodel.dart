import 'package:chatapp/models/chat/chat_page_model.dart';
import 'package:chatapp/models/notes.dart';
import 'package:chatapp/models/user/user_model.dart';
import 'package:chatapp/repositories/chat_repo/chat_repo_imp.dart';
import 'package:chatapp/utils/routes.dart';
import 'package:chatapp/utils/sharedPreferenced.dart';
import 'package:chatapp/utils/snackbar.dart';
import 'package:chatapp/utils/sqlite_db.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sqflite/sqflite.dart';

class HomeVM extends GetxController with GetSingleTickerProviderStateMixin {
  bool isUserAuthenticated = false;
  Future<bool> userAuthentication() async {
    return await (SharedPrefs.getBool('isLoggedIn')) ?? false;
  }

  late Database db;
  List<NotesModel> notes = [];
  void dataBase() async {
    bool errorIni = false;

    errorIni = await DB.initializedDB(db);
    notes = await DB.offlineData(db, "notes");
    if (errorIni || notes.isEmpty) {
      showSnackBar(Get.context!, "Error while loading data.", true);
    }
  }

  String selectedCategory = "";

  void addNotes() async {
    NotesModel note = NotesModel(
      id: notes.length + 1,
      text: notesController.text.trim(),
      title: noteTitleController.text.trim(),
      dateTime: DateTime.now().toString(),
      categories: selectedCategory,
      selected: false,
    );
    bool isDataInserted = await DB.insertDataIntoDB(db, note.toMap(), "notes");
    if (!isDataInserted) {
      showSnackBar(Get.context!, "Error while inserting data", true);
    } else {
      showSnackBar(Get.context!, "Notes Added", false);
    }
  }

  void deleteNotes(int id) async {
    bool isDeleted = await DB.deleteFromDb(db, id);
    if (isDeleted) {
      showSnackBar(Get.context!, "Note Deleted", false);
    } else {
      showSnackBar(Get.context!, "Error while deleting note", true);
    }
  }

  @override
  void onInit() async {
    tabController = TabController(vsync: this, length: 2);
    isUserAuthenticated = await userAuthentication();
    dataBase();
    getAllChatUsers();
    initPlatform();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Notes'),
    const Tab(text: 'BookMarks'),
  ];

  final List<Color> color = [
    Colors.blueGrey,
    Colors.green,
    Colors.grey,
    Colors.redAccent,
    Colors.yellowAccent,
  ];

  List<ChatUsers> chatUsersList = [];
  bool loading = false;
  ChatRepoImp chatRepoImp = ChatRepoImp();
  TextEditingController searchController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController noteTitleController = TextEditingController();
  late TabController tabController;

  void getAllChatUsers() async {
    loading = true;
    print("loading : $loading");
    update();
    List<ChatUsers> chatList = await chatRepoImp.getAllChatUsers();
    chatUsersList = chatList;

    loading = false;
    update();
  }

  bool searchLoading = false;
  List<UserData> searchList = [];

  void getSearchedUsers() async {
    if (searchController.text.isEmpty) {
      showSnackBar(Get.context!, "Please enter some text to search", true);
      return;
    }
    searchLoading = true;
    update();
    searchList = await chatRepoImp.getSearchedUsers(searchController.text);
    print(searchList.length);
    searchLoading = false;
    update();
  }

  Future<void> initPlatform() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId("90dda10a-86d2-4f79-a30d-0620cff40d00");

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print("result ttttt : ${event.notification.body}");
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Handle notification opened event here
      print("result ppppp : ${result.notification.body}");
    });

    if ((await SharedPrefs.getString("notificationId")) != null) return;
    await OneSignal.shared.getDeviceState().then((deviceState) {
      debugPrint("Device State: ${deviceState!.userId}");
      SharedPrefs.setString("notificationId", deviceState.userId!);
    });
  }

  String convertDateTime(DateTime dateTime) {
    debugPrint("Convert Date time:  function Called");
    debugPrint("dateTime : $dateTime");
    dateTime = dateTime.toUtc().toLocal();
    String time = dateTime.toString().substring(11, 16);
    String hour = time.substring(0, 2);
    String min = time.substring(3, 5);
    String ampm = "AM";
    if (int.parse(hour) > 12) {
      hour = (int.parse(hour) - 12).toString();
      ampm = "PM";
    }
    return "$hour:$min $ampm";
  }
}
