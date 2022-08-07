import 'package:easy_task/data/data_source/project_source.dart';
import 'package:easy_task/data/projec/project.dart';

abstract class IProjectRepository extends IProjectDataSource {}

class ProjectRepository implements IProjectRepository {
  final IProjectDataSource dataSource;

  ProjectRepository(this.dataSource);
  @override
  List<ProjectEntity> getProjects() => dataSource.getProjects();
}
