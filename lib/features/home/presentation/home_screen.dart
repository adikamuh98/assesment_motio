import 'package:appflowy_board/appflowy_board.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/usecases/add_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/delete_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/get_all_groups.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_group.dart';
import 'package:assesment_motio/features/home/presentation/bloc/auth_bloc.dart';
import 'package:assesment_motio/features/home/presentation/bloc/home_screen_cubit.dart';
import 'package:assesment_motio/features/home/presentation/components/add_task_dialog.dart';
import 'package:assesment_motio/features/home/presentation/components/card_item_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenCubit homeScreenCubit;

  @override
  void initState() {
    super.initState();
    homeScreenCubit = HomeScreenCubit(
      getAllGroupsUsecase: context.read<GetAllGroups>(),
      addGroupUsecase: context.read<AddGroup>(),
      updateGroupUsecase: context.read<UpdateGroup>(),
      deleteGroupUsecase: context.read<DeleteGroup>(),
    )..init();
  }

  @override
  void dispose() {
    homeScreenCubit.close();
    super.dispose();
  }

  // void _initGroup() {
  //   final groupTodo = GroupModel(id: 'todo', name: 'To Do');
  //   final groupInProgress = GroupModel(id: 'in_progress', name: 'In Progress');
  //   final groupPending = GroupModel(id: 'pending', name: 'Pending');
  //   final groupDone = GroupModel(id: 'done', name: 'Done');

  //   final group1 = AppFlowyGroupData(
  //     id: groupTodo.id,
  //     name: groupTodo.name,
  //     items: <AppFlowyGroupItem>[
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupTodo,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupTodo,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupTodo,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupTodo,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupTodo,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupTodo,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupTodo,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //     ],
  //   );

  //   final group2 = AppFlowyGroupData(
  //     id: groupInProgress.id,
  //     name: groupInProgress.name,
  //     items: <AppFlowyGroupItem>[
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupInProgress,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //     ],
  //   );

  //   final group3 = AppFlowyGroupData(
  //     id: groupPending.id,
  //     name: groupPending.name,
  //     items: <AppFlowyGroupItem>[
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupInProgress,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //     ],
  //   );
  //   final group4 = AppFlowyGroupData(
  //     id: groupDone.id,
  //     name: groupDone.name,
  //     items: <AppFlowyGroupItem>[
  //       TaskModel(
  //         id: 'asdfasdf',
  //         name: 'Meeting with client',
  //         description: 'Discuss project requirements',
  //         group: groupDone,
  //         isCompleted: false,
  //         dueDate: '15-05-2025 10:00:00',
  //         createdAt: '2020-08-01 10:00:00',
  //         updatedAt: '2020-08-01 10:00:00',
  //       ),
  //     ],
  //   );

  //   controller.addGroup(group1);
  //   controller.addGroup(group2);
  //   controller.addGroup(group3);
  //   controller.addGroup(group4);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add your logout logic here
              context.read<AuthBloc>().add(Logout());
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeScreenCubit, StateController<HomeScreenState>>(
        bloc: homeScreenCubit,
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 700,
                child: AppFlowyBoard(
                  controller: homeScreenCubit.controller,
                  boardScrollController: homeScreenCubit.boardController,
                  groupConstraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width - 50,
                  ),
                  cardBuilder: (context, group, groupItem) {
                    return AppFlowyGroupCard(
                      key: ValueKey(groupItem.id),
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: CardItemComponent(
                        taskModel: groupItem as TaskModel,
                      ),
                    );
                  },
                  headerBuilder: (context, groupData) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 24,
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text(
                              groupData.headerData.groupName,
                              style: appFonts.subtitle.semibold.ts,
                            ),
                          ),
                          AppButton(
                            icon: Icons.add,
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AddTaskDialog(),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  config: AppFlowyBoardConfig(
                    groupBackgroundColor: appColors.background,
                    groupBodyPadding: const EdgeInsets.all(10),
                    groupCornerRadius: 12,
                    groupMargin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
