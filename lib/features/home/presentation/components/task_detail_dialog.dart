import 'package:assesment_motio/core/formatter/date_formatter.dart';
import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskDetailDialog extends StatelessWidget {
  final TaskModel taskModel;
  final Function() markTaskAsDone;
  final Function() markTaskAsUndone;
  final Function() deleteTask;
  final Function() editTask;
  const TaskDetailDialog({
    super.key,
    required this.taskModel,
    required this.markTaskAsDone,
    required this.markTaskAsUndone,
    required this.deleteTask,
    required this.editTask,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              taskModel.name,
              style:
                  appFonts.subtitle.semibold
                      .copyWith(color: appColors.black)
                      .ts,
            ),
            const SizedBox(height: 8),
            Text(
              taskModel.description,
              style: appFonts.copyWith(color: appColors.black).ts,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 8,
                    children: [
                      Text(
                        'Due date',
                        style:
                            appFonts.caption
                                .copyWith(color: appColors.black)
                                .ts,
                      ),
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
                              DateFormatter.formatDisplayDate(
                                taskModel.dueDate,
                              ),
                              style: appFonts.caption.ts,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (taskModel.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text('Done', style: appFonts.caption.success.ts),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Expanded(
          child: AppButton(
            text: taskModel.isCompleted ? 'Mark as Undone' : 'Mark as Done',
            onTap: () {
              if (taskModel.isCompleted) {
                markTaskAsUndone.call();
              } else {
                markTaskAsDone.call();
              }
            },
            color:
                taskModel.isCompleted ? appColors.warning : appColors.success,
            type: AppButtonType.small,
          ),
        ),
        AppButton(text: 'Edit', onTap: editTask, type: AppButtonType.small),
        AppButton(
          text: 'Delete',
          onTap: deleteTask,
          color: appColors.error,
          type: AppButtonType.small,
        ),
      ],
    );
  }
}
