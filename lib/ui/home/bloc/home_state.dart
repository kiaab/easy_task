part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<TaskEntity> tasks;

  final List<String> projects;
  final List<String> tags;

  const HomeSuccess(
    this.tasks,
    this.projects,
    this.tags,
  );
}

class HomeSuccessSearch extends HomeState {
  final List<TaskEntity> tasks;
  final List<TaskEntity> tasksSearch;

  const HomeSuccessSearch(this.tasks, this.tasksSearch);
}

class HomeError extends HomeState {}

class EmptyState extends HomeState {}
