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
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        _onMoveGroupItem.call(groupId, fromIndex, toIndex);
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},
    );
  }

  // final AppFlowyBoardController controller = AppFlowyBoardController(
  //   onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},
  //   onMoveGroupItem: (groupId, fromIndex, toIndex) {
  //     _onMoveGroupItem.call(groupId, fromIndex, toIndex);
  //   },
  //   onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},

  final AppFlowyBoardScrollController boardController =
      AppFlowyBoardScrollController();

  void init() async {
    emit(StateController.loading());
    try {
      final groups = _sortGroups(await getAllGroupsUsecase.call());
      for (var group in groups) {
        controller.addGroup(
          AppFlowyGroupData(id: group.id, name: group.name, items: group.items),
        );
      }
      emit(StateController.success(HomeScreenState(groups: groups)));
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(StateController.error(errorMessage: 'Failed to load groups'));
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

  void _onMoveGroupItem(String groupId, int fromIndex, int toIndex) async {
    try {
      final curGroup = state.inferredData?.groups.firstWhereOrNull(
        (group) => group.id == groupId,
      );

      if (curGroup == null) {
        emit(StateController.error(errorMessage: 'Group not found'));
        return;
      }

      final task = curGroup.items[fromIndex];
      final updatedItems = <TaskModel>[];
      for (var i = 0; i < curGroup.items.length; i++) {
        updatedItems.add(curGroup.items[i].copyWith(orderIndex: i));
      }
      final updatedGroup = curGroup.copyWith(items: updatedItems);
      // final newestGroup = updatedGroup.copyWith(
      //   items:
      //       updatedGroup.items.mapIndexed((index, item) {
      //         return item.copyWith(orderIndex: index);
      //       }).toList(),
      // );
      await updateGroupUsecase.call(updatedGroup);
      init();
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(StateController.error(errorMessage: 'Failed to move task'));
    }
  }
}
