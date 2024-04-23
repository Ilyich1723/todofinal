import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todofinal/model/todo_model.dart';


class ToDoDatabaseService {
  CollectionReference toDoCollection =
      FirebaseFirestore.instance.collection("ToDoList");

      //For ToDo order based on their addin times
      Stream <List<TodoModel>> listTodo(){
        return toDoCollection.orderBy("Timestamp",descending:true)
        .snapshots()
        .map(todoFromFirestore);

      }// after that the most recemt added items are top on the list
  Future createNewTodo(String title) async{
    return await toDoCollection.add({
      "title":title,
      "isCompleted":false,
      "Timestamp":FieldValue.serverTimestamp(),

    });

  }
  Future updateTaskTitle(String uid, String newTitle) async {
    await toDoCollection.doc(uid).update({"title": newTitle});
}
  //For updating the ToDo
  Future updateTask(uid,bool newCompletedTask) async{
    await toDoCollection.doc(uid).update({"isCompleted":newCompletedTask});

  }

// For delete the ToDo
Future deleteTodo(uid) async{
  await toDoCollection.doc(uid).delete();

}
List<TodoModel> todoFromFirestore(QuerySnapshot snapshot){
  return snapshot.docs.map((e) {
  Map <String,dynamic> ? data = e.data()
  as Map<String,dynamic>?;

return TodoModel(
  
  isCompleted: data?['isCompleted']?? false,
  title: data?['title'] ?? "",
  uid: e.id);

  }).toList();
}
}
