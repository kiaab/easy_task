import 'package:easy_task/data/projec/project.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class IProjectDataSource {
  List<ProjectEntity> getProjects();
}

class ProjectDataSource implements IProjectDataSource {
  final Box<ProjectEntity> box;

  ProjectDataSource(this.box);
  @override
  List<ProjectEntity> getProjects() {
    return box.values.toList();
  }
}
