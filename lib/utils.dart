import 'package:easy_task/ui/home/home_screen.dart';

void checkedProjectIsInListAndAdd(String projectName) {
  if (projectName.isNotEmpty && !projects.contains(projectName)) {
    projects.add(projectName);
  }
}

void checkedTagIsInListAndAdd(String tagName) {
  if (tagName.isNotEmpty && !tags.contains(tagName)) {
    tags.add(tagName);
  }
}
