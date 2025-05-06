import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/repositories/task_repository.dart';

class AddTaskToGroup {
  final TaskRepository taskRepository;

  AddTaskToGroup(this.taskRepository);

  Future<void> call(String groupId, TaskModel task) async {
    await taskRepository.addTaskToGroup(groupId, task);
  }
}
