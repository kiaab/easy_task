import 'package:easy_task/data/task.dart';
import 'package:hive_flutter/adapters.dart';

abstract class ITaskDataSource {
  Future<List<TaskEntity>> getTasks();

  Future<TaskEntity> addOrUpdate(TaskEntity task);

  Future<void> delete(TaskEntity task);

  Future<void> deleteAll();
}

class TaskDataSource implements ITaskDataSource {
  final Box<TaskEntity> taskBox;

  TaskDataSource(this.taskBox);
  @override
  Future<TaskEntity> addOrUpdate(TaskEntity task) async {
    if (task.isInBox) {
      await task.save();
    } else {
      await taskBox.add(task);
    }
    return task;
  }

  @override
  Future<void> delete(TaskEntity task) async {
    await task.delete();
  }

  @override
  Future<void> deleteAll() async {
    await taskBox.clear();
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    return taskBox.values.toList();
  }
}
