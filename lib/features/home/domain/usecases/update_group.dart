import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/domain/repositories/task_repository.dart';

class UpdateGroup {
  final TaskRepository taskRepository;
  const UpdateGroup(this.taskRepository);

  Future<void> call(GroupModel group) async {
    await taskRepository.updateGroup(group);
  }
}
