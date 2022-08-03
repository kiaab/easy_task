import 'package:bloc/bloc.dart';
import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:equatable/equatable.dart';

part 'add_or_edit_event.dart';
part 'add_or_edit_state.dart';

class AddOrEditBloc extends Bloc<AddOrEditEvent, AddOrEditState> {
  final ITaskRepository taskRepository;
  AddOrEditBloc(this.taskRepository) : super(AddOrEditInitial()) {
    on<AddOrEditEvent>((event, emit) async {
      if (event is SaveButtonClicked) {
        await taskRepository.addOrUpdate(event.task);
      } else if (event is TitleFieldIsEmpty) {
        emit(AddOrEditError());
      }
    });
  }
}
