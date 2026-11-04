class TodoModel {
  final int? id;
  final String title;
  final bool completed;
  final int userId;

  TodoModel({
    this.id,
    required this.title,
    this.completed = false,
    this.userId = 1,
  });

  // Dart object -> Map (before jsonEncode, when sending)
  Map<String, dynamic> toJson() => {
    'title': title,
    'completed': completed,
    'userId': userId,
  };

  // Map -> Dart object (after jsonDecode, when receiving)
  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    id: json['id'],
    title: json['title'],
    completed: json['completed'],
    userId: json['userId'],
  );
}