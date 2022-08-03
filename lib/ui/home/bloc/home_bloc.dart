import 'dart:math';

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
      if (event is HomeStarted || event is SearchFieldClicked) {
        emit(HomeLoading());
        final String searchKey;
        try {
          if (event is SearchFieldClicked) {
            searchKey = event.searchKey;
          } else {
            searchKey = '';
          }
          final tasks = await taskRepository.getTasks(searchKey);
          if (tasks.isEmpty && event is HomeStarted) {
            emit(EmptyState());
          } else {
            emit(HomeSuccess(tasks));
          }
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is UpdateTask) {
        taskRepository.addOrUpdate(event.task);
      }
    });
  }
}
