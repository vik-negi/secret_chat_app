// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/services.dart';

class NotesModel {
  int id;
  String text;
  String title;
  String dateTime;
  String categories;
  bool selected;
  Uint8List? image;
  NotesModel({
    required this.id,
    required this.text,
    required this.title,
    required this.dateTime,
    required this.categories,
    required this.selected,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'title': title,
      'dateTime': dateTime,
      'Categories': categories,
      'selected': selected,
      'image': image?.asMap(),
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'] as int,
      text: map['text'] ?? "",
      title: map['title'] ?? "",
      dateTime: map['dateTime'] ?? DateTime.now().toString(),
      categories: map['Categories'] ?? "",
      selected: map['selected'] ?? false,
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) =>
      NotesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
