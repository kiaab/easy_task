import 'package:bloc/bloc.dart';
import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:equatable/equatable.dart';

part 'task_bottom_sheet_event.dart';
part 'task_bottom_sheet_state.dart';

class TaskBottomSheetBloc
    extends Bloc<TaskBottomSheetEvent, TaskBottomSheetState> {
  final ITaskRepository taskRepository;
  TaskBottomSheetBloc(this.taskRepository) : super(TaskBottomSheetInitial()) {
    on<TaskBottomSheetEvent>((event, emit) {
      if (event is TaskBottomSheetStarted) {
        emit(TaskBottomSheetSuccess(taskRepository.getTask(event.taskId)));
      } else if (event is TaskBottomSheetCheckedClicked) {
        taskRepository.addOrUpdate(event.task);
        emit(TaskBottomSheetSuccess(taskRepository.getTask(event.task.key)));
      }
    });
  }
}
