import 'package:bloc/bloc.dart';
import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/utils.dart';

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
          List<TaskEntity> tasks = taskRepository.getTasks();
          if (event is SearchFieldClicked) {
            searchKey = event.searchKey;
            tasks = tasks
                .where((element) =>
                    element.title.contains(searchKey) ||
                    element.tag.contains(searchKey))
                .toList();
          } else if (event is HomeStarted) {
            searchKey = '';
          } else {
            searchKey = '';
          }

          //get tag list if it's already empty
          List<String> tags = [];
          getTags(tags, tasks);
          //get project list if it's already empty
          List<String> projects = [];
          getProjects(projects, tasks);

          if (tasks.isEmpty && event is HomeStarted) {
            emit(EmptyState());
          } else {
            emit(HomeSuccess(tasks, projects, tags));
          }
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is AddOrUpdateTask) {
        //update or add task in database
        taskRepository.addOrUpdate(event.task);
      } else if (event is DeleteTask) {
        //remove task from database
        taskRepository.delete(event.task);
      } else if (event is DeleteAll) {
        //clear database
        taskRepository.deleteAll();
      } else if (event is DeleteAllProjectTasks) {
        for (var e in event.tasks) {
          await taskRepository.delete(e);
        }
      }
    });
  }
}
