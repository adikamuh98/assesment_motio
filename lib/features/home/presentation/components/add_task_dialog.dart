import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/core/themes/app_text_field.dart';
import 'package:assesment_motio/features/home/presentation/bloc/add_task_dialog_cubit.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late final AddTaskDialogCubit _addTaskDialogCubit;

  @override
  void initState() {
    super.initState();
    _addTaskDialogCubit = AddTaskDialogCubit();
  }

  @override
  void dispose() {
    _addTaskDialogCubit.close();
    super.dispose();
  }

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text('Add Task', style: appFonts.subtitle.semibold.ts),
            AppTextField(
              controller: _addTaskDialogCubit.nameController,
              label: 'Name',
            ),
            AppTextField(
              controller: _addTaskDialogCubit.descriptionController,
              label: 'Description',
              multiLines: true,
            ),
            AppButton(text: 'Add', isFitParent: true),
          ],
        ),
      ),
    );
  }
}
