part of 'task_bottom_sheet_bloc.dart';

abstract class TaskBottomSheetEvent extends Equatable {
  const TaskBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class TaskBottomSheetStarted extends TaskBottomSheetEvent {
  final int taskId;

  const TaskBottomSheetStarted(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class TaskBottomSheetCheckedClicked extends TaskBottomSheetEvent {
  final TaskEntity task;

  const TaskBottomSheetCheckedClicked(this.task);
  @override
  List<Object> get props => [task];
}
