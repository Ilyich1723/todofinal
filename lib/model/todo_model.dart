class TodoModel {
  String uid;
  String title;
  String description; // Убедитесь, что это поле добавлено
  bool isCompleted;
  
  TodoModel({
    required this.uid, 
    required this.isCompleted, 
    required this.title,
    required this.description // И это обновлено
  });
}
