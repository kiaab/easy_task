part of 'add_or_edit_bloc.dart';

abstract class AddOrEditEvent extends Equatable {
  const AddOrEditEvent();

  @override
  List<Object> get props => [];
}

class EditStarted extends AddOrEditEvent {}

class Save extends AddOrEditEvent {
  final TaskEntity task;

  const Save(this.task);

  @override
  List<Object> get props => [task];
}
