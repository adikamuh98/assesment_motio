import 'package:assesment_motio/features/home/domain/repositories/task_repository.dart';

class DeleteGroup {
  final TaskRepository taskRepository;

  DeleteGroup(this.taskRepository);

  Future<void> call(String groupId) async {
    await taskRepository.deleteGroup(groupId);
  }
}
