part of 'add_or_edit_bloc.dart';

abstract class AddOrEditEvent extends Equatable {
  const AddOrEditEvent();

  @override
  List<Object> get props => [];
}

class EditStarted extends AddOrEditEvent {}
