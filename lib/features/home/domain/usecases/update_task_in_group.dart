import 'package:assesment_motio/features/home/data/models/task_model.dart';
import 'package:assesment_motio/features/home/domain/repositories/task_repository.dart';

class UpdateTaskInGroup {
  final TaskRepository taskRepository;

  UpdateTaskInGroup(this.taskRepository);

  Future<void> call(String groupId, TaskModel task) async {
    await taskRepository.updateTaskInGroup(groupId, task);
  }
}
