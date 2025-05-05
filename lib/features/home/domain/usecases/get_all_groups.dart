import 'package:assesment_motio/features/home/data/models/group_model.dart';
import 'package:assesment_motio/features/home/domain/repositories/task_repository.dart';

class GetAllGroups {
  final TaskRepository taskRepository;

  GetAllGroups(this.taskRepository);

  Future<List<GroupModel>> call() async {
    return await taskRepository.getAllGroups();
  }
}
