import 'package:assesment_motio/core/services/hive_service.dart';
import 'package:assesment_motio/features/home/data/models/group_model.dart';

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
}
