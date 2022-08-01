import 'package:bloc/bloc.dart';
import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ITaskRepository taskRepository;
  HomeBloc({required this.taskRepository}) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted) {
        emit(HomeLoading());
        try {
          final tasks = await taskRepository.getTasks();
          emit(HomeSuccess(tasks));
        } catch (e) {
          emit(HomeError());
        }
      }
    });
  }
}
