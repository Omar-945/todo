import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/user_dao.dart';

import 'models/task.dart';

class TasksDao {
  static var date = DateTime.now();

  static bool isFirst = true;

  static CollectionReference<Task> getTaskCollection(String? userId) {
    return UserDao.getUserCollection()
        .doc(userId)
        .collection(Task.collectionName)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()),
            toFirestore: (taskObject, options) => taskObject.toFireStore());
  }

  static Future<void> addTask(Task userTask, String userId) {
    var tasksCollectio = getTaskCollection(userId);
    var task = tasksCollectio.doc();
    userTask.id = task.id;
    return task.set(userTask);
  }

  static Stream<List<Task>> getSearchTasks(String userId) async* {
    var filter = date.copyWith(
        microsecond: 0, millisecond: 0, second: 0, minute: 0, hour: 0);
    var taskCollection = getTaskCollection(userId);
    var tasksSnapshot = taskCollection
        .where('date',
            isEqualTo: Timestamp.fromMillisecondsSinceEpoch(
                filter.millisecondsSinceEpoch))
        .snapshots();
    var snapShots = tasksSnapshot
        .map((snapshots) => snapshots.docs.map((e) => e.data()).toList());
    yield* snapShots;
  }

  static Stream<List<Task>> getTasks(String userId) async* {
    isFirst = false;
    var taskCollection = getTaskCollection(userId);
    var tasksSnapshot = taskCollection.snapshots();
    var snapShots = tasksSnapshot
        .map((snapshots) => snapshots.docs.map((e) => e.data()).toList());
    yield* snapShots;
  }

  static Future<void> deleteTask(String? id, String? taskId) async {
    var taskCollection = getTaskCollection(id);
    return await taskCollection.doc(taskId).delete();
  }

  static Future<void> updateTask(String? userId, String? taskId, Map<String, dynamic> newTask) {
    var taskCollection = getTaskCollection(userId);
    return taskCollection.doc(taskId).update(newTask);
  }
}
