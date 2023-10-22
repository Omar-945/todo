import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  static const collectionName = 'Tasks';
  String? id;
  String? title;
  String? content;
  Timestamp? date;
  bool? isDone;

  Task({this.id, this.title, this.content, this.date, this.isDone = false});

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "date": date,
      "isdone": isDone
    };
  }

  Task.fromFireStore(Map<String, dynamic>? data) {
    id = data?["id"];
    title = data?["title"];
    content = data?["content"];
    date = data?["date"];
    isDone = data?["isdone"];
  }
}
