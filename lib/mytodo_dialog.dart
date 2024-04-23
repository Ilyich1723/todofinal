import 'package:flutter/material.dart';
import 'package:todofinal/service/todo_database_service.dart';

class TodoDialog extends StatelessWidget {
  const TodoDialog({super.key, required this.todoTitleController,required this.todoDescriptionController});
  final TextEditingController todoTitleController;
  final TextEditingController todoDescriptionController;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(children: [
        const Text(
          "ДОБАВИТЬ ЗАДАЧУ",
          style: TextStyle(
              fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.white,
            ))
      ]),
      children: [
        TextFormField(
          controller: todoTitleController,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          autofocus: true,
          decoration: const InputDecoration(
              hintText: "укажите вашу задачу",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        TextFormField(
          controller: todoDescriptionController,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          autofocus: true,
          decoration: const InputDecoration(
              hintText: "укажите описание задачи",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              if (todoTitleController.text.isNotEmpty && todoDescriptionController.text.isNotEmpty) {
                await ToDoDatabaseService()
                    .createNewTodo(todoTitleController.text.trim(), todoDescriptionController.text.trim());
              }
              // For Dismiss the dialog
              Navigator.pop(context);
              // For clear the textfield
              todoTitleController.clear();
              todoDescriptionController.clear();
            },
            child: const Text("добавить"),
          ),
        )
      ],
    );
  }
}
