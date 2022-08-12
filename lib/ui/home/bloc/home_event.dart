part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeStarted extends HomeEvent {}

class SearchFieldClicked extends HomeEvent {
  final String searchKey;

  const SearchFieldClicked({this.searchKey = ''});
}

class AddOrUpdateTask extends HomeEvent {
  final TaskEntity task;

  const AddOrUpdateTask(this.task);
}

class DeleteTask extends HomeEvent {
  final TaskEntity task;

  const DeleteTask(this.task);
}

class DeleteAll extends HomeEvent {}

class TagClicked extends HomeEvent {
  final String selectedTag;

  const TagClicked(this.selectedTag);
}

class DeleteAllProjectTasks extends HomeEvent {
  final List<TaskEntity> tasks;

  const DeleteAllProjectTasks(this.tasks);
}
