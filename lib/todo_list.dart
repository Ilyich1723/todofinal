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
  TextEditingController todoDescriptionController = TextEditingController();
  TextEditingController todoEditController = TextEditingController();
  TextEditingController todoEditDescriptionController = TextEditingController();

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
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                                subtitle: Text(
                                  todo[index]
                                      .description, // отображение описания задачи
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                                          content: Column(
                                            children: [
                                              TextFormField(
                                                controller: todoEditController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'укажите вашу задачу'),
                                              ),
                                              TextFormField(
                                                controller:
                                                    todoEditDescriptionController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'укажите описание вашей задачи'),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Сохранить'),
                                              onPressed: () async {
                                                if (todoEditController
                                                        .text.isNotEmpty &&
                                                    todoEditDescriptionController
                                                        .text.isNotEmpty) {
                                                  await ToDoDatabaseService()
                                                      .updateTaskTitle(
                                                          todo[index].uid,
                                                          todoEditController
                                                              .text
                                                              .trim());
                                                  await ToDoDatabaseService()
                                                      .updateTaskDescription(
                                                          todo[index].uid,
                                                          todoEditDescriptionController
                                                              .text
                                                              .trim());
                                                  Navigator.of(context).pop();
                                                  todoEditController.clear();
                                                  todoEditDescriptionController
                                                      .clear();
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
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
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TodoDialog(
              todoTitleController: todoTitleController,
              todoDescriptionController: todoDescriptionController,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
