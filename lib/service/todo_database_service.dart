import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:todofinal/model/todo_model.dart';

class ToDoDatabaseService {
  CollectionReference toDoCollection =
      FirebaseFirestore.instance.collection("ToDoList");

  Stream<List<TodoModel>> listTodo() {
    return toDoCollection
        .orderBy("Timestamp", descending: true)
        .snapshots()
        .map(todoFromFirestore);
  }

  Future createNewTodo(String title, String description) async {
    return await toDoCollection.add({
      "title": title,
      "description": description,
      "isCompleted": false,
      "Timestamp": FieldValue.serverTimestamp(),
    });
  }

  //выполнено/не выполнено
  Future updateTask(uid, bool newCompletedTask) async {
    await toDoCollection.doc(uid).update({"isCompleted": newCompletedTask});
  }

  Future updateTaskDescription(String uid, String newDescription) async {
    await toDoCollection.doc(uid).update({"description": newDescription});
  }

  Future updateTaskTitle(String uid, String newTitle) async {
    await toDoCollection.doc(uid).update({"title": newTitle});
  }

// удаления
  Future deleteTodo(uid) async {
    await toDoCollection.doc(uid).delete();
  }

  List<TodoModel> todoFromFirestore(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      Map<String, dynamic>? data = e.data() as Map<String, dynamic>?;

      return TodoModel(
        isCompleted: data?['isCompleted'] ?? false,
        title: data?['title'] ?? "",
        uid: e.id,
        description: data?['description'] ?? "",
      );
    }).toList();
  }
}
