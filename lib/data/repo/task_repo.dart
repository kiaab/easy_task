import 'package:easy_task/data/data_source/task_source.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:hive_flutter/adapters.dart';

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
  List<TaskEntity> getTasks() => dataSource.getTasks();

  @override
  TaskEntity getTask(int id) => dataSource.getTask(id);
}

final TaskRepository taskRepository =
    TaskRepository(TaskDataSource(Hive.box<TaskEntity>(taskBoxName)));
