import 'package:assesment_motio/core/formatter/date_formatter.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/presentation/components/add_task_dialog.dart';
import 'package:flutter/material.dart';

class CardItemComponent extends StatelessWidget {
  final String groupId;
  final TaskModel taskModel;
  final Function()? onTaskUpdated;
  const CardItemComponent({
    super.key,
    required this.groupId,
    required this.taskModel,
    this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder:
              (context) => AddTaskDialog(
                groupId: groupId,
                taskModel: taskModel,
                onTaskAdded: () {
                  onTaskUpdated?.call();
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
            Text(taskModel.name, style: appFonts.semibold.ts),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: appColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, color: appColors.black, size: 14),
                  Text(
                    DateFormatter.formatDisplayDate(taskModel.dueDate),
                    style: appFonts.caption.ts,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
