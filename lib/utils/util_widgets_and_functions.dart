import 'package:chatapp/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UtilWidgetsAndFunctions {
  static final monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String getTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.isNegative) {
      return "Someone from future posted this event";
    } else if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} years ago";
    } else if (difference.inDays > 31) {
      return "${(difference.inDays / 31).floor()} months ago";
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Posted Just now';
    }
  }

  static getCorrectDateTimeFormat(String dateTime) {
    try {
      return DateTime.parse(dateTime);
    } catch (e) {
      return DateFormat('y-M-d hh:mm').parse(dateTime);
    }
  }

  static String suffixBigNumber(String number) {
    double integerNumber = double.parse(number);

    if (integerNumber >= 1000000000000) {
      return "${(integerNumber / 1000000000000).toStringAsFixed(1)}T";
    } else if (integerNumber >= 1000000000) {
      return "${(integerNumber / 1000000000).toStringAsFixed(1)}B";
    } else if (integerNumber >= 1000000) {
      return "${(integerNumber / 1000000).toStringAsFixed(1)}M";
    } else if (integerNumber >= 1000) {
      return "${(integerNumber / 1000).toStringAsFixed(1)}K";
    } else {
      return integerNumber.toStringAsFixed(0);
    }
  }

  static Widget gapx(double x) {
    return SizedBox(
      width: x.toDouble(),
    );
  }

  static Widget gapy(double x) {
    return SizedBox(
      height: x.toDouble(),
    );
  }

  static appSnakBar(
      {required String message, double? maxwidth, bool isError = true}) {
    return Get.rawSnackbar(
      icon: isError ? const Icon(Icons.error) : const Icon(Icons.check),
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      maxWidth: maxwidth ?? Get.width * 0.8,
      margin: EdgeInsets.only(bottom: Get.height * 0.1),
      borderRadius: 16,
      duration: const Duration(seconds: 2),
    );
  }
}
