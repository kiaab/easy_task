part of 'add_or_edit_bloc.dart';

abstract class AddOrEditEvent extends Equatable {
  const AddOrEditEvent();

  @override
  List<Object> get props => [];
}

class SaveButtonClicked extends AddOrEditEvent {
  final TaskEntity task;

  const SaveButtonClicked(this.task);
  @override
  List<Object> get props => [task];
}

class TitleFieldIsEmpty extends AddOrEditEvent {}
