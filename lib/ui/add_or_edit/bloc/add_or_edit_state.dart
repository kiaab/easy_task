part of 'add_or_edit_bloc.dart';

abstract class AddOrEditState extends Equatable {
  const AddOrEditState();

  @override
  List<Object> get props => [];
}

class AddOrEditInitial extends AddOrEditState {}

class EditSuccess extends AddOrEditState {
  final List<String> projects;
  final List<String> tags;

  const EditSuccess(this.projects, this.tags);

  @override
  List<Object> get props => [projects, tags];
}
