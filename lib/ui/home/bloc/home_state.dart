part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<TaskEntity> tasks;
  final List<TaskEntity> tasksSearch;

  const HomeSuccess(this.tasks, this.tasksSearch);
  @override
  List<Object> get props => [tasks];
}

class HomeError extends HomeState {}

class EmptyState extends HomeState {}
