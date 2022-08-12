import 'package:bloc/bloc.dart';
import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/utils.dart';
import 'package:equatable/equatable.dart';

part 'add_or_edit_event.dart';
part 'add_or_edit_state.dart';

class AddOrEditBloc extends Bloc<AddOrEditEvent, AddOrEditState> {
  final ITaskRepository taskRepository;
  AddOrEditBloc(this.taskRepository) : super(AddOrEditInitial()) {
    on<AddOrEditEvent>((event, emit) async {
      if (event is EditStarted) {
        //get all tasks from database
        final tasks = taskRepository.getTasks();

        //get tag list if it's already empty
        List<String> tags = [];
        getTags(tags, tasks);
        //get project list if it's already empty
        List<String> projects = [];
        getProjects(projects, tasks);
        emit(EditSuccess(projects, tags));
      }
    });
  }
}
