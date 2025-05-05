import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'group_model.g.dart';

@HiveType(typeId: 0)
class GroupModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<TaskModel> items;

  const GroupModel({required this.id, required this.name, required this.items});

  @override
  List<Object?> get props => [id, name, items];

  GroupModel copyWith({
    String? id,
    String? name,
    List<TaskModel>? items,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}
