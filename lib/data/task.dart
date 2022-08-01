import 'package:hive_flutter/adapters.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
class TaskEntity extends HiveObject {
  @HiveField(0)
  String content;
  @HiveField(1, defaultValue: false)
  bool checked;
  @HiveField(2, defaultValue: false)
  bool important;

  TaskEntity(this.content, this.checked, this.important);
}
