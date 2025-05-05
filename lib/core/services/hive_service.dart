import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._internal();
  static final HiveService _instance = HiveService._internal();
  static HiveService get instance => _instance;

  final String _groupBoxName = 'groupBox';
  final String _taskBoxName = 'taskBox';

  final String _groupTodoId = 'todo';
  final String _groupInProgressId = 'in_progress';
  final String _groupPendingId = 'pending';
  final String _groupDoneId = 'done';

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(GroupModelAdapter());
    Hive.registerAdapter(TaskModelAdapter());

    await _initGroupBox();
  }

  Future<void> _initGroupBox() async {
    final groups = await getAllGroups();

    if (groups.isEmpty) {
      final groupTodo = GroupModel(id: _groupTodoId, name: 'To Do', items: []);
      final groupInProgress = GroupModel(
        id: _groupInProgressId,
        name: 'In Progress',
        items: [],
      );
      final groupPending = GroupModel(
        id: _groupPendingId,
        name: 'Pending',
        items: [],
      );
      final groupDone = GroupModel(id: _groupDoneId, name: 'Done', items: []);

      await addGroup(groupTodo);
      await addGroup(groupInProgress);
      await addGroup(groupPending);
      await addGroup(groupDone);
    } else {
      final groupTodo = groups.firstWhere(
        (group) => group.id == _groupTodoId,
        orElse: () => GroupModel(id: _groupTodoId, name: 'To Do', items: []),
      );
      final groupInProgress = groups.firstWhere(
        (group) => group.id == _groupInProgressId,
        orElse:
            () => GroupModel(
              id: _groupInProgressId,
              name: 'In Progress',
              items: [],
            ),
      );
      final groupPending = groups.firstWhere(
        (group) => group.id == _groupPendingId,
        orElse:
            () => GroupModel(id: _groupPendingId, name: 'Pending', items: []),
      );
      final groupDone = groups.firstWhere(
        (group) => group.id == _groupDoneId,
        orElse: () => GroupModel(id: _groupDoneId, name: 'Done', items: []),
      );

      await updateGroup(groupTodo);
      await updateGroup(groupInProgress);
      await updateGroup(groupPending);
      await updateGroup(groupDone);
    }
  }

  Future<Box<GroupModel>> openGroupBox() async {
    return await Hive.openBox<GroupModel>(_groupBoxName);
  }

  Future<Box<TaskModel>> openTaskBox() async {
    return await Hive.openBox<TaskModel>(_taskBoxName);
  }

  Future<void> closeGroupBox() async {
    final box = await openGroupBox();
    await box.close();
  }

  Future<void> closeTaskBox() async {
    final box = await openTaskBox();
    await box.close();
  }

  Future<void> deleteGroupBox() async {
    final box = await openGroupBox();
    await box.deleteFromDisk();
  }

  Future<void> deleteTaskBox() async {
    final box = await openTaskBox();
    await box.deleteFromDisk();
  }

  Future<void> clearGroupBox() async {
    final box = await openGroupBox();
    await box.clear();
  }

  Future<void> clearTaskBox() async {
    final box = await openTaskBox();
    await box.clear();
  }

  Future<void> addGroup(GroupModel group) async {
    final box = await openGroupBox();
    await box.put(group.id, group);
  }

  Future<void> addTask(TaskModel task) async {
    final box = await openTaskBox();
    await box.put(task.id, task);
  }

  Future<GroupModel?> getGroup(String id) async {
    final box = await openGroupBox();
    return box.get(id);
  }

  Future<TaskModel?> getTask(String id) async {
    final box = await openTaskBox();
    return box.get(id);
  }

  Future<List<GroupModel>> getAllGroups() async {
    final box = await openGroupBox();
    return box.values.toList();
  }

  Future<List<TaskModel>> getAllTasks() async {
    final box = await openTaskBox();
    return box.values.toList();
  }

  Future<void> deleteGroup(String id) async {
    final box = await openGroupBox();
    await box.delete(id);
  }

  Future<void> deleteTask(String id) async {
    final box = await openTaskBox();
    await box.delete(id);
  }

  Future<void> updateGroup(GroupModel group) async {
    final box = await openGroupBox();
    await box.put(group.id, group);
  }

  Future<void> updateTask(TaskModel task) async {
    final box = await openTaskBox();
    await box.put(task.id, task);
  }

  Future<void> clearAll() async {
    await clearGroupBox();
    await clearTaskBox();
  }

  Future<void> closeAll() async {
    await closeGroupBox();
    await closeTaskBox();
  }

  Future<void> deleteAll() async {
    await deleteGroupBox();
    await deleteTaskBox();
  }
}
