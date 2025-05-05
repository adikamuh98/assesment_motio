import 'package:assesment_motio/core/models/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskDialogCubit extends Cubit<StateController<bool>> {
  AddTaskDialogCubit() : super(StateController.idle());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Future<void> close() async {
    nameController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.close();
  }
}
