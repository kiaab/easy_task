part of 'add_or_edit_bloc.dart';

abstract class AddOrEditState extends Equatable {
  const AddOrEditState();

  @override
  List<Object> get props => [];
}

class AddOrEditInitial extends AddOrEditState {}

class AddOrEditError extends AddOrEditState {}
