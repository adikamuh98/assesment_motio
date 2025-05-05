import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/domain/repositories/task_repository.dart';

class AddGroup {
  final TaskRepository taskRepository;
  const AddGroup(this.taskRepository);

  Future<void> call(GroupModel group) async {
    await taskRepository.addGroup(group);
  }
}
