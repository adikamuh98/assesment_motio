import 'package:assesment_motio/core/formatter/date_formatter.dart';
import 'package:assesment_motio/core/helper/string_helper.dart';
import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/usecases/add_task_to_group.dart';
import 'package:assesment_motio/features/home/domain/usecases/update_task_in_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AddTaskDialogCubit extends Cubit<StateController<bool>> {
  final AddTaskToGroup addTaskToGroupUsecase;
  final UpdateTaskInGroup updateTaskInGroupUsecase;

  AddTaskDialogCubit({
    required this.addTaskToGroupUsecase,
    required this.updateTaskInGroupUsecase,
  }) : super(StateController.idle());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDueDate;

  @override
  Future<void> close() async {
    nameController.dispose();
    descriptionController.dispose();
    super.close();
  }

  void addTask(String groupId) async {
    try {
      emit(StateController.loading());
      if (nameController.text.isEmpty) {
        emit(StateController.error(errorMessage: 'Name cannot be empty'));
        return;
      }
      if (descriptionController.text.isEmpty) {
        emit(
          StateController.error(errorMessage: 'Description cannot be empty'),
        );
        return;
      }
      if (selectedDueDate == null) {
        emit(StateController.error(errorMessage: 'Due date cannot be empty'));
        return;
      }

      final task = TaskModel(
        taskId: StringHelper.generateRandomString(10),
        name: nameController.text,
        description: descriptionController.text,
        isCompleted: false,
        dueDate: DateFormatter.formatDateTime(selectedDueDate!),
        createdAt: DateFormatter.formatDateTime(DateTime.now()),
        updatedAt: DateFormatter.formatDateTime(DateTime.now()),
        orderIndex: 0,
      );

      await addTaskToGroupUsecase.call(groupId, task);
      emit(StateController.success(true));
    } catch (e, s) {
      Logger().e('Error adding task', error: e, stackTrace: s);
      emit(StateController.error(errorMessage: 'Failed to add task'));
    }
  }

  void updateTask(String groupId, TaskModel taskModel) async {
    try {
      emit(StateController.loading());
      if (nameController.text.isEmpty) {
        emit(StateController.error(errorMessage: 'Name cannot be empty'));
        return;
      }
      if (descriptionController.text.isEmpty) {
        emit(
          StateController.error(errorMessage: 'Description cannot be empty'),
        );
        return;
      }
      if (selectedDueDate == null) {
        emit(StateController.error(errorMessage: 'Due date cannot be empty'));
        return;
      }

      final updatedTask = taskModel.copyWith(
        name: nameController.text,
        description: descriptionController.text,
        dueDate: DateFormatter.formatDateTime(selectedDueDate!),
        updatedAt: DateFormatter.formatDateTime(DateTime.now()),
      );

      await updateTaskInGroupUsecase.call(groupId, updatedTask);
      emit(StateController.success(true));
    } catch (e, s) {
      Logger().e('Error updating task', error: e, stackTrace: s);
      emit(StateController.error(errorMessage: 'Failed to update task'));
    }
  }

  void init(TaskModel? taskModel) {
    if (taskModel != null) {
      nameController.text = taskModel.name;
      descriptionController.text = taskModel.description;
      selectedDueDate = DateFormatter.parse(taskModel.dueDate);
    }
  }

  void setSelectedDueDate(DateTime date) {
    selectedDueDate = date;
  }
}
