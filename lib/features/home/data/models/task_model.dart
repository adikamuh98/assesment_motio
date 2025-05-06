import 'package:appflowy_board/appflowy_board.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends AppFlowyGroupItem {
  @HiveField(0)
  final String taskId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool isCompleted;
  @HiveField(4)
  final String dueDate;
  @HiveField(5)
  final String createdAt;
  @HiveField(6)
  final String updatedAt;
  @HiveField(7)
  final int orderIndex;

  TaskModel({
    required this.taskId,
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.orderIndex,
  });

  @override
  String get id => taskId;

  TaskModel copyWith({
    String? taskId,
    String? name,
    String? description,
    bool? isCompleted,
    String? dueDate,
    String? createdAt,
    String? updatedAt,
    int? orderIndex,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      name: name ?? this.name,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
