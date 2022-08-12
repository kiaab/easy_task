import 'package:easy_task/data/task.dart';

void checkedProjectIsInListAndAdd(String projectName, List<String> projects) {
  if (projectName.isNotEmpty && !projects.contains(projectName)) {
    projects.add(projectName);
  }
}

void checkedTagIsInListAndAdd(String tagName, List<String> tags) {
  if (tagName.isNotEmpty && !tags.contains(tagName)) {
    tags.add(tagName);
  }
}

void getProjects(List<String> projects, List<TaskEntity> tasks) {
  if (projects.isEmpty) {
    for (var e in tasks) {
      checkedProjectIsInListAndAdd(e.projectName, projects);
    }
  }
}

void getTags(List<String> tags, List<TaskEntity> tasks) {
  if (tags.isEmpty) {
    for (var e in tasks) {
      checkedTagIsInListAndAdd(e.tag, tags);
    }
  }
}
