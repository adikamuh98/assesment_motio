import 'package:appflowy_board/appflowy_board.dart';
import 'package:assesment_motio/core/formatter/date_formatter.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/presentation/components/add_task_dialog.dart';
import 'package:assesment_motio/features/home/presentation/components/task_detail_dialog.dart';
import 'package:flutter/material.dart';

class CardItemComponent extends StatelessWidget {
  final String groupId;
  final TaskModel taskModel;
  // final Function()? onTaskUpdated;
  final AppFlowyBoardController boardController;
  final Function() markTaskAsDone;
  final Function() markTaskAsUndone;
  final Function() deleteTask;
  const CardItemComponent({
    super.key,
    required this.groupId,
    required this.taskModel,
    // this.onTaskUpdated,
    required this.boardController,
    required this.markTaskAsDone,
    required this.markTaskAsUndone,
    required this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => TaskDetailDialog(
                taskModel: taskModel,
                markTaskAsDone: () {
                  markTaskAsDone.call();
                  Navigator.of(context).pop();
                },
                markTaskAsUndone: () {
                  markTaskAsUndone.call();
                  Navigator.of(context).pop();
                },
                deleteTask: () {
                  deleteTask.call();
                  Navigator.of(context).pop();
                },
                editTask: () async {
                  Navigator.of(context).pop();
                  await showDialog(
                    context: context,
                    builder:
                        (context) => AddTaskDialog(
                          groupId: groupId,
                          taskModel: taskModel,
                          boardController: boardController,
                        ),
                  );
                },
              ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: appColors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8,
              children: [
                Text(taskModel.name, style: appFonts.semibold.ts),
                InkWell(
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: appColors.black,
                    size: 14,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: appColors.black,
                        size: 14,
                      ),
                      Text(
                        DateFormatter.formatDisplayDate(taskModel.dueDate),
                        style: appFonts.caption.ts,
                      ),
                    ],
                  ),
                ),
                if (taskModel.isCompleted)
                  Icon(Icons.check_circle, color: appColors.success, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBottomSheetItem(
              title: taskModel.isCompleted ? 'Mark as undone' : 'Mark as done',
              icon: Icons.check_circle_outline,
              onTap: () {
                if (taskModel.isCompleted) {
                  markTaskAsUndone.call();
                } else {
                  markTaskAsDone.call();
                }
                Navigator.of(context).pop();
              },
            ),
            _buildBottomSheetItem(
              title: 'Edit',
              icon: Icons.edit,
              onTap: () async {
                Navigator.of(context).pop();
                await showDialog(
                  context: context,
                  builder:
                      (context) => AddTaskDialog(
                        groupId: groupId,
                        taskModel: taskModel,
                        boardController: boardController,
                        onTaskAdded: () {
                          // onTaskUpdated?.call();
                        },
                      ),
                );
              },
            ),
            _buildBottomSheetItem(
              title: 'Delete',
              icon: Icons.delete,
              iconColor: appColors.error,
              textColor: appColors.error,
              onTap: () {
                deleteTask.call();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSheetItem({
    required String title,
    required IconData icon,
    Color? iconColor,
    Color? textColor,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          spacing: 8,
          children: [
            Icon(icon, color: iconColor ?? appColors.black),
            Text(title, style: appFonts.ts.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
