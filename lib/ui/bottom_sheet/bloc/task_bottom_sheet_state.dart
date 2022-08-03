part of 'task_bottom_sheet_bloc.dart';

abstract class TaskBottomSheetState extends Equatable {
  const TaskBottomSheetState();

  @override
  List<Object> get props => [];
}

class TaskBottomSheetInitial extends TaskBottomSheetState {}

class TaskBottomSheetSuccess extends TaskBottomSheetState {
  final TaskEntity task;

  const TaskBottomSheetSuccess(this.task);
}
