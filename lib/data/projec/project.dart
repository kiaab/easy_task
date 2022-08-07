import 'package:hive_flutter/adapters.dart';
part 'project.g.dart';

@HiveType(typeId: 1)
class ProjectEntity extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  double progres;

  ProjectEntity({this.title = '', this.progres = 0});
}
