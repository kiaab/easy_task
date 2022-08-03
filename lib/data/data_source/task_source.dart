import 'package:easy_task/data/task.dart';
import 'package:hive_flutter/adapters.dart';

abstract class ITaskDataSource {
  Future<List<TaskEntity>> getTasks(String searchKey);

  TaskEntity getTask(int id);

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
  Future<List<TaskEntity>> getTasks(String searchKey) async {
    if (searchKey.isNotEmpty) {
      return taskBox.values.where((element) {
        return element.title.contains(searchKey) ||
            element.tag.contains(searchKey);
      }).toList();
    } else {
      return taskBox.values.toList();
    }
  }

  @override
  TaskEntity getTask(int id) {
    return taskBox.get(id)!;
  }
}
