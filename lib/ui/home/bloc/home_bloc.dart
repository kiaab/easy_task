import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:equatable/equatable.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ITaskRepository taskRepository;
  HomeBloc({required this.taskRepository}) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is SearchFieldClicked) {
        emit(HomeLoading());
        final String searchKey;
        final String date;

        try {
          if (event is SearchFieldClicked) {
            searchKey = event.searchKey;
            date = event.date;
          } else if (event is HomeStarted) {
            searchKey = '';
            date = event.date;
          } else {
            date = Jalali.now().formatFullDate();
            searchKey = '';
          }
          final tasks = taskRepository.getTasks();
          final List<TaskEntity> tasksSearch;
          if (searchKey.isNotEmpty) {
            tasksSearch = tasks
                .where((element) => element.title.contains(searchKey))
                .toList();
          } else {
            tasksSearch = tasks;
          }
          if (tasks.isEmpty && event is HomeStarted) {
            emit(EmptyState());
          } else {
            emit(HomeSuccess(tasks, tasksSearch));
          }
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is UpdateTask) {
        taskRepository.addOrUpdate(event.task);
      } else if (event is DeleteTask) {
        for (var e in event.task) {
          taskRepository.delete(e);
        }
      } else if (event is DeleteAll) {
        taskRepository.deleteAll();
      }
    });
  }
}
