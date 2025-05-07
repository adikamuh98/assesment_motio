import 'package:appflowy_board/appflowy_board.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/usecases/add_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/delete_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/get_all_groups.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_task_in_group.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class HomeScreenState extends Equatable {
  final List<GroupModel> groups;

  const HomeScreenState({required this.groups});

  HomeScreenState copyWith({List<GroupModel>? groups}) {
    return HomeScreenState(groups: groups ?? this.groups);
  }

  @override
  List<Object?> get props => [groups];
}

class HomeScreenCubit extends Cubit<StateController<HomeScreenState>> {
  final GetAllGroups getAllGroupsUsecase;
  final AddGroup addGroupUsecase;
  final UpdateGroup updateGroupUsecase;
  final DeleteGroup deleteGroupUsecase;
  final UpdateTaskInGroup updateTaskInGroupUsecase;
  late final AppFlowyBoardController controller;

  HomeScreenCubit({
    required this.getAllGroupsUsecase,
    required this.addGroupUsecase,
    required this.updateGroupUsecase,
    required this.deleteGroupUsecase,
    required this.updateTaskInGroupUsecase,
  }) : super(StateController.idle(data: HomeScreenState(groups: []))) {
    controller = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},
      onMoveGroupItem: _onMoveGroupItem,
      onMoveGroupItemToGroup: _onMoveGroupItemToGroup,
    );
  }

  final AppFlowyBoardScrollController boardController =
      AppFlowyBoardScrollController();

  void init() async {
    emit(StateController.loading(data: state.inferredData));
    try {
      final groups = _sortGroups(await getAllGroupsUsecase.call());
      for (var group in groups) {
        controller.addGroup(
          AppFlowyGroupData(
            id: group.id,
            name: group.name,
            items: List<AppFlowyGroupItem>.from(group.items),
          ),
        );
      }
      emit(StateController.success(HomeScreenState(groups: groups)));
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(
        StateController.error(
          errorMessage: 'Failed to load groups',
          data: state.inferredData,
        ),
      );
    }
  }

  List<GroupModel> _sortGroups(List<GroupModel> groups) {
    final groupOrder = ['todo', 'in_progress', 'pending', 'done'];

    groups.sort((a, b) {
      final indexA = groupOrder.indexOf(a.id);
      final indexB = groupOrder.indexOf(b.id);
      return indexA.compareTo(indexB);
    });
    return groups.map((group) {
      final sortedItems = _sortTasks(group.items);
      return group.copyWith(items: sortedItems);
    }).toList();
  }

  List<TaskModel> _sortTasks(List<TaskModel> tasks) {
    tasks.sort((a, b) {
      return a.orderIndex.compareTo(b.orderIndex);
    });
    return tasks;
  }

  void markTaskAsDone(String groupId, TaskModel task) async {
    try {
      emit(StateController.loading(data: state.inferredData));
      final updatedTask = task.copyWith(isCompleted: true);
      final group = state.inferredData?.groups.firstWhereOrNull(
        (group) => group.id == groupId,
      );
      if (group != null) {
        final updatedItems =
            List<TaskModel>.from(group.items)
              ..removeWhere((t) => t.taskId == task.taskId)
              ..add(updatedTask);
        final updatedGroup = group.copyWith(items: updatedItems);
        await updateGroupUsecase.call(updatedGroup);
        controller.updateGroupItem(groupId, updatedTask);
        init();
      } else {
        emit(
          StateController.error(
            errorMessage: 'Group not found',
            data: state.inferredData,
          ),
        );
      }
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(
        StateController.error(
          errorMessage: 'Failed to mark task as done',
          data: state.inferredData,
        ),
      );
    }
  }

  void markTaskAsUndone(String groupId, TaskModel task) async {
    try {
      emit(StateController.loading(data: state.inferredData));
      final updatedTask = task.copyWith(isCompleted: false);
      final group = state.inferredData?.groups.firstWhereOrNull(
        (group) => group.id == groupId,
      );
      if (group != null) {
        final updatedItems =
            List<TaskModel>.from(group.items)
              ..removeWhere((t) => t.taskId == task.taskId)
              ..add(updatedTask);
        final updatedGroup = group.copyWith(items: updatedItems);
        await updateGroupUsecase.call(updatedGroup);
        controller.updateGroupItem(groupId, updatedTask);
        init();
      } else {
        emit(
          StateController.error(
            errorMessage: 'Group not found',
            data: state.inferredData,
          ),
        );
      }
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(
        StateController.error(
          errorMessage: 'Failed to mark task as undone',
          data: state.inferredData,
        ),
      );
    }
  }

  void deleteTaskFromGroup(String groupId, TaskModel task) async {
    try {
      emit(StateController.loading(data: state.inferredData));
      final group = state.inferredData?.groups.firstWhereOrNull(
        (group) => group.id == groupId,
      );
      if (group != null) {
        final updatedItems = List<TaskModel>.from(group.items)
          ..removeWhere((t) => t.taskId == task.taskId);
        final updatedGroup = _updateTaskOrderIndex(
          group.copyWith(items: updatedItems),
        );
        await updateGroupUsecase.call(updatedGroup);
        controller.removeGroupItem(groupId, task.taskId);
        init();
      } else {
        emit(
          StateController.error(
            errorMessage: 'Group not found',
            data: state.inferredData,
          ),
        );
      }
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(
        StateController.error(
          errorMessage: 'Failed to delete task',
          data: state.inferredData,
        ),
      );
    }
  }

  void _onMoveGroupItem(String groupId, int fromIndex, int toIndex) async {
    try {
      final curGroup = state.inferredData?.groups.firstWhereOrNull(
        (group) => group.id == groupId,
      );

      if (curGroup == null) {
        emit(StateController.error(errorMessage: 'Group not found'));
        return;
      }

      final updatedGroup = _updateTaskOrderIndex(curGroup);
      await updateGroupUsecase.call(updatedGroup);
      init();
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(
        StateController.error(
          errorMessage: 'Failed to move task',
          data: state.inferredData,
        ),
      );
    }
  }

  void _onMoveGroupItemToGroup(
    String fromGroupId,
    int fromIndex,
    String toGroupId,
    int toIndex,
  ) async {
    try {
      final fromGroup = state.inferredData?.groups.firstWhereOrNull(
        (group) => group.id == fromGroupId,
      );
      final toGroup = state.inferredData?.groups.firstWhereOrNull(
        (group) => group.id == toGroupId,
      );

      if (fromGroup == null || toGroup == null) {
        emit(StateController.error(errorMessage: 'Group not found'));
        return;
      }

      final movedTask = fromGroup.items[fromIndex];
      final updatedFromItems = List<TaskModel>.from(fromGroup.items)
        ..removeAt(fromIndex);
      final updatedToItems = List<TaskModel>.from(toGroup.items)
        ..insert(toIndex, movedTask.copyWith(orderIndex: toIndex));

      final updatedFromGroup = _updateTaskOrderIndex(
        fromGroup.copyWith(items: updatedFromItems),
      );
      final updatedToGroup = _updateTaskOrderIndex(
        toGroup.copyWith(items: updatedToItems),
      );

      // await updateTaskInGroupUsecase.call(
      //   fromGroupId,
      //   movedTask.copyWith(orderIndex: toIndex),
      // );
      await updateGroupUsecase.call(updatedFromGroup);
      await updateGroupUsecase.call(updatedToGroup);
      init();
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(
        StateController.error(
          errorMessage: 'Failed to move task',
          data: state.inferredData,
        ),
      );
    }
  }

  GroupModel _updateTaskOrderIndex(GroupModel group) {
    final updatedItems = <TaskModel>[];
    for (var i = 0; i < group.items.length; i++) {
      updatedItems.add(group.items[i].copyWith(orderIndex: i));
    }

    return group.copyWith(items: updatedItems);
  }
}
