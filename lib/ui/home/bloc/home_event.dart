part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent {
  final String date;

  const HomeStarted(this.date);

  @override
  List<Object> get props => [date];
}

class SearchFieldClicked extends HomeEvent {
  final String searchKey;
  final String date;
  const SearchFieldClicked(this.date, {this.searchKey = ''});

  @override
  List<Object> get props => [date];
}

class UpdateTask extends HomeEvent {
  final TaskEntity task;

  const UpdateTask(this.task);
  @override
  List<Object> get props => [task];
}
