import 'package:appflowy_board/appflowy_board.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends AppFlowyGroupItem {
  @HiveField(0)
  late final String _id;
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

  TaskModel({
    String id = '',
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  }) {
    _id = id;
  }

  @override
  String get id => _id;

  TaskModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isCompleted,
    String? dueDate,
    String? createdAt,
    String? updatedAt,
  }) {
    return TaskModel(
      id: id ?? _id,
      name: name ?? this.name,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
