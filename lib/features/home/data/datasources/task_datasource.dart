import 'package:assesment_motio/core/services/hive_service.dart';
import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';

class TaskDatasource {
  Future<List<GroupModel>> getAllGroups() async {
    return await HiveService.instance.getAllGroups();
  }

  Future<void> addGroup(GroupModel group) async {
    await HiveService.instance.addGroup(group);
  }

  Future<void> updateGroup(GroupModel group) async {
    await HiveService.instance.updateGroup(group);
  }

  Future<void> deleteGroup(String groupId) async {
    await HiveService.instance.deleteGroup(groupId);
  }

  Future<void> addTaskToGroup(String groupId, TaskModel task) async {
    final group = await HiveService.instance.getGroup(groupId);
    if (group != null) {
      group.items.add(task.copyWith(orderIndex: group.items.length));
      await HiveService.instance.updateGroup(group);
    } else {
      throw Exception('Group not found');
    }
  }

  Future<void> updateTaskInGroup(String groupId, TaskModel task) async {
    final group = await HiveService.instance.getGroup(groupId);
    if (group != null) {
      final index = group.items.indexWhere((t) => t.taskId == task.taskId);
      if (index != -1) {
        group.items[index] = task;
        await HiveService.instance.updateGroup(group);
      } else {
        throw Exception('Task not found in group');
      }
    } else {
      throw Exception('Group not found');
    }
  }
}
