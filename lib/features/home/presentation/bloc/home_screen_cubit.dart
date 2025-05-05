import 'package:appflowy_board/appflowy_board.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/usecases/add_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/delete_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/get_all_groups.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_group.dart';
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

  HomeScreenCubit({
    required this.getAllGroupsUsecase,
    required this.addGroupUsecase,
    required this.updateGroupUsecase,
    required this.deleteGroupUsecase,
  }) : super(StateController.idle(data: HomeScreenState(groups: [])));

  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},
    onMoveGroupItem: (groupId, fromIndex, toIndex) {},
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {},
  );
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
    return groups;
  }

  void addTask(String groupId, TaskModel task) async {
    emit(StateController.loading(data: state.inferredData));
    try {
      final group = state.inferredData!.groups.firstWhere(
        (g) => g.id == groupId,
      );
      final updatedGroup = group.copyWith(items: [...group.items, task]);

      await addGroupUsecase.call(updatedGroup);
      init();
    } catch (e, s) {
      Logger().e(e.toString(), error: e, stackTrace: s);
      emit(StateController.error(errorMessage: 'Failed to add task'));
    }
  }
}
