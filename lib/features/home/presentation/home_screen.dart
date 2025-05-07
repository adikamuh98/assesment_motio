import 'package:appflowy_board/appflowy_board.dart';
import 'package:assesment_motio/core/helper/snackbar_helper.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/core/widget/app_alert_dialog.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/usecases/add_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/delete_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/get_all_groups.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_task_in_group.dart';
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
      updateTaskInGroupUsecase: context.read<UpdateTaskInGroup>(),
    )..init();
  }

  @override
  void dispose() {
    homeScreenCubit.close();
    super.dispose();
  }

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
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AppAlertDialog(
                    text: 'Are you sure you want to logout?',
                    content:
                        'You will be logged out of your account and all data will be erased.',
                    contentIcon: Icon(
                      Icons.warning_amber_outlined,
                      color: appColors.error,
                      size: 40,
                    ),
                    cancelText: 'Cancel',
                    acceptText: 'Logout',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onAccept: () {
                      context.read<AuthBloc>().add(Logout());
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<HomeScreenCubit, StateController<HomeScreenState>>(
        bloc: homeScreenCubit,
        listener: (context, state) {
          if (state is Error) {
            SnackbarHelper.error(
              message: state.inferredErrorMessage ?? 'Error occurred',
            );
          }
        },
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
                        groupId: group.headerData.groupId,
                        taskModel: groupItem as TaskModel,
                        boardController: homeScreenCubit.controller,
                        markTaskAsDone: () {
                          homeScreenCubit.markTaskAsDone(
                            group.headerData.groupId,
                            groupItem,
                          );
                        },
                        markTaskAsUndone: () {
                          homeScreenCubit.markTaskAsUndone(
                            group.headerData.groupId,
                            groupItem,
                          );
                        },
                        deleteTask: () {
                          homeScreenCubit.deleteTaskFromGroup(
                            group.headerData.groupId,
                            groupItem,
                          );
                        },
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
                                builder:
                                    (context) => AddTaskDialog(
                                      groupId: groupData.headerData.groupId,
                                      boardController:
                                          homeScreenCubit.controller,
                                      onTaskAdded: () {
                                        homeScreenCubit.init();
                                      },
                                    ),
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
