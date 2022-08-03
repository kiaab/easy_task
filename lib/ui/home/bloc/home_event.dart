part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent {}

class SearchFieldClicked extends HomeEvent {
  final String searchKey;

  const SearchFieldClicked([this.searchKey = '']);
}

class CheckedClicked extends HomeEvent {
  final TaskEntity task;

  const CheckedClicked(this.task);
  @override
  List<Object> get props => [task];
}
