import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:assesment_motio/core/helper/snackbar_helper.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/core/services/storage_service.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Home', style: appFonts.subtitle.semibold.ts),
        backgroundColor: appColors.white,
        surfaceTintColor: appColors.white,
        foregroundColor: appColors.black,
        shadowColor: appColors.black,
        centerTitle: true,
        leading: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.menu, color: appColors.black),
          ),
        ),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        color: AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            ListTile(
              title: Text('Dark Mode', style: appFonts.subtitle.ts),
              trailing: Switch(
                activeColor: appColors.primary,
                activeTrackColor: appColors.primarySwatch.shade100,
                trackColor: WidgetStatePropertyAll(
                  appColors.primarySwatch.shade100,
                ),
                thumbColor: WidgetStatePropertyAll(appColors.primary),
                trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                value: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
                onChanged: (_) {
                  if (AdaptiveTheme.of(context).mode ==
                      AdaptiveThemeMode.dark) {
                    AdaptiveTheme.of(context).setLight();
                    SecureStorageService.instance.writeSecureData(
                      SecureKey.themeMode,
                      'light',
                    );
                  } else {
                    AdaptiveTheme.of(context).setDark();
                    SecureStorageService.instance.writeSecureData(
                      SecureKey.themeMode,
                      'dark',
                    );
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Logout', style: appFonts.subtitle.ts),
              onTap: () {
                showDialog(
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
      ),
      backgroundColor: appColors.white,
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
              Expanded(
                child: AppFlowyBoard(
                  controller: homeScreenCubit.controller,
                  scrollController: _scrollController,
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
