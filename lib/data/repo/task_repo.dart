import 'package:easy_task/data/data_source/task_source.dart';
import 'package:easy_task/data/task.dart';

abstract class ITaskRepository extends ITaskDataSource {}

class TaskRepository implements ITaskRepository {
  final ITaskDataSource dataSource;

  TaskRepository(this.dataSource);
  @override
  Future<TaskEntity> addOrUpdate(TaskEntity task) =>
      dataSource.addOrUpdate(task);

  @override
  Future<void> delete(TaskEntity task) => dataSource.delete(task);

  @override
  Future<void> deleteAll() => dataSource.deleteAll();

  @override
  List<TaskEntity> getTasks(String searchKey) => dataSource.getTasks(searchKey);

  @override
  TaskEntity getTask(int id) => dataSource.getTask(id);
}
