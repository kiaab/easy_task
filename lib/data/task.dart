import 'package:hive_flutter/adapters.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
class TaskEntity extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String content;
  @HiveField(2)
  String tag;
  @HiveField(3)
  bool checked;
  @HiveField(4)
  bool important;

  TaskEntity(
      {this.title = '',
      this.content = '',
      this.tag = '',
      this.checked = false,
      this.important = false});
}
