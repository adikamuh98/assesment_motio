import 'package:assesment_motio/core/helper/snackbar_helper.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/core/themes/app_button.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_date_field.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/core/themes/app_text_field.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/usecases/add_task_to_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_task_in_group.dart';
import 'package:assesment_motio/features/home/presentation/bloc/add_task_dialog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AddTaskDialog extends StatefulWidget {
  final String groupId;
  final TaskModel? taskModel;
  final Function()? onTaskAdded;
  const AddTaskDialog({
    super.key,
    required this.groupId,
    this.onTaskAdded,
    this.taskModel,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late final AddTaskDialogCubit _addTaskDialogCubit;

  @override
  void initState() {
    super.initState();
    _addTaskDialogCubit = AddTaskDialogCubit(
      addTaskToGroupUsecase: context.read<AddTaskToGroup>(),
      updateTaskInGroupUsecase: context.read<UpdateTaskInGroup>(),
    )..init(widget.taskModel);
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
        child: BlocListener<AddTaskDialogCubit, StateController<bool>>(
          bloc: _addTaskDialogCubit,
          listener: (context, state) {
            if (state is Loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }

            if (state is Error) {
              SnackbarHelper.error(message: state.inferredErrorMessage ?? '');
            }

            if (state is Success) {
              if (widget.taskModel != null) {
                SnackbarHelper.success(message: 'Task updated successfully');
              } else {
                SnackbarHelper.success(message: 'Task added successfully');
              }
              widget.onTaskAdded?.call();
              Navigator.of(context).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text(
                widget.taskModel == null ? 'Add Task' : 'Update Task',
                style: appFonts.subtitle.semibold.ts,
              ),
              AppTextField(
                controller: _addTaskDialogCubit.nameController,
                label: 'Name',
              ),
              AppTextField(
                controller: _addTaskDialogCubit.descriptionController,
                label: 'Description',
                multiLines: true,
              ),
              AppDateField(
                label: 'Due Date',
                initialDate: _addTaskDialogCubit.selectedDueDate,
                onDateSelected: (date) {
                  _addTaskDialogCubit.setSelectedDueDate(date);
                },
              ),
              if (widget.taskModel == null)
                AppButton(
                  text: 'Add',
                  isFitParent: true,
                  onTap: () {
                    _addTaskDialogCubit.addTask(widget.groupId);
                  },
                ),
              if (widget.taskModel != null)
                AppButton(
                  text: 'Update',
                  isFitParent: true,
                  onTap: () {
                    _addTaskDialogCubit.updateTask(
                      widget.groupId,
                      widget.taskModel!,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
