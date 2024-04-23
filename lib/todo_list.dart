import 'package:flutter/material.dart';
import 'package:todofinal/loader.dart';
import 'package:todofinal/model/todo_model.dart';
import 'package:todofinal/mytodo_dialog.dart';
import 'package:todofinal/service/todo_database_service.dart';


class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  TextEditingController todoTitleController = TextEditingController();
  TextEditingController todoEditController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder<List<TodoModel>>(
            stream: ToDoDatabaseService().listTodo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loader();
              }
              List<TodoModel>? todo = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Список дел",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: todo!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(todo[index].uid),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.red,
                            child: const Icon(Icons.delete),
                          ),
                          onDismissed: (direction) async {
                            await ToDoDatabaseService()
                                .deleteTodo(todo[index].uid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              child: ListTile(
                                onTap: () {
                                  bool newComleteTask =
                                      !todo[index].isCompleted;
                                  ToDoDatabaseService().updateTask(
                                      todo[index].uid, newComleteTask);
                                },
                                leading: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                     color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: todo[index].isCompleted
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.black,
                                        )
                                      : Container(),
                                ),
                                title: Text(
                                  todo[index].title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  onPressed: () {
                                    todoEditController.text = todo[index].title;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Редактировать задачу'),
                                          content: TextFormField(
                                            controller: todoEditController,
                                            style: const TextStyle(fontSize: 20, color: Colors.black),
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                                hintText: "укажите вашу задачу",
                                                hintStyle: TextStyle(color: Colors.black)),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Сохранить'),
                                              onPressed: () async {
                                                if (todoEditController.text.isNotEmpty) {
                                                  await ToDoDatabaseService()
                                                      .updateTaskTitle(todo[index].uid, todoEditController.text.trim());
                                                  Navigator.of(context).pop();
                                                  todoEditController.clear();
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            })),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: ((context) => TodoDialog(todoTitleController: todoTitleController)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}