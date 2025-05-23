import 'package:assesment_motio/features/home/data/datasources/task_datasource.dart';
import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';

class TaskRepository {
  final TaskDatasource datasource;
  TaskRepository({required this.datasource});

  Future<List<GroupModel>> getAllGroups() async {
    return await datasource.getAllGroups();
  }

  Future<void> addGroup(GroupModel group) async {
    await datasource.addGroup(group);
  }

  Future<void> updateGroup(GroupModel group) async {
    await datasource.updateGroup(group);
  }

  Future<void> deleteGroup(String groupId) async {
    await datasource.deleteGroup(groupId);
  }

  Future<void> addTaskToGroup(String groupId, TaskModel task) async {
    await datasource.addTaskToGroup(groupId, task);
  }

  Future<void> updateTaskInGroup(String groupId, TaskModel task) async {
    await datasource.updateTaskInGroup(groupId, task);
  }
}
