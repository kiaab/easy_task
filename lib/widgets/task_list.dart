import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';
import 'package:easy_task/ui/bottom_sheet/botttom_sheet.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:easy_task/ui/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    Key? key,
    required this.tasks,
    required this.theme,
    required this.bloc,
    required this.projects,
    required this.tags,
  }) : super(key: key);

  final List<TaskEntity> tasks;
  final ThemeData theme;
  final Bloc? bloc;
  final List<String> projects;
  final List<String> tags;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 70),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemExtent: 90,
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          for (var element in widget.tasks) {
            if (element.important == true) {
              widget.tasks.remove(element);
              widget.tasks.insert(0, element);
            }
          }

          final task = widget.tasks[index];
          bool? checked = task.checked;
          return Stack(
            children: [
              Visibility(
                visible: task.important,
                child: Container(
                  height: 90,
                  margin: const EdgeInsets.fromLTRB(32, 4, 32, 2),
                  decoration: BoxDecoration(
                      color: checked ? null : Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              GestureDetector(
                onLongPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddOrEditScreen(
                            projects: widget.projects,
                            task: task,
                            tags: widget.tags,
                          )));
                },
                onTap: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(36))),
                      context: context,
                      builder: (context) {
                        return TaskBottomSheet(
                          task: task,
                          theme: widget.theme,
                        );
                      });
                },
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                  margin: EdgeInsets.fromLTRB(
                      32, 4, task.important && !checked ? 36 : 32, 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: checked
                          ? widget.theme.colorScheme.secondary.withOpacity(0.2)
                          : Colors.white,
                      border: checked
                          ? Border.all(
                              color: widget.theme.colorScheme.secondary
                                  .withOpacity(0.2))
                          : Border.all(
                              color: task.important
                                  ? Colors.red
                                  : MyApp.primaryTextColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              task.important = !task.important;
                              if (widget.bloc is HomeBloc) {
                                widget.bloc?.add(UpdateTask(task));
                              } else {
                                getIt<TaskRepository>().addOrUpdate(task);
                              }
                            },
                            child: Icon(
                              task.important
                                  ? CupertinoIcons.flag_fill
                                  : CupertinoIcons.flag,
                              size: 18,
                              color: task.important
                                  ? Colors.red
                                  : MyApp.primaryTextColor,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                  decoration: checked
                                      ? TextDecoration.lineThrough
                                      : null),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Checkbox(
                              side: BorderSide(
                                  color: widget.theme.colorScheme.secondary,
                                  width: 2),
                              activeColor: widget.theme.colorScheme.secondary,
                              value: checked,
                              onChanged: (value) {
                                task.checked = value!;
                                if (widget.bloc is HomeBloc &&
                                    widget.bloc != null) {
                                  widget.bloc?.add(UpdateTask(task));
                                } else {
                                  getIt<TaskRepository>().addOrUpdate(task);
                                }
                              })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: task.projectName.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                task.projectName,
                                style: widget.theme.textTheme.bodyText1!
                                    .copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: AlertDialog(
                                          title: Text(
                                            'آیا از حذف خود مطمعن هستید',
                                            style: widget
                                                .theme.textTheme.headline4,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                if (widget.bloc is HomeBloc) {
                                                  widget.bloc
                                                      ?.add(DeleteTask([task]));
                                                  deleteProjectName(task);
                                                  deleteTagName(task);
                                                } else {
                                                  getIt<TaskRepository>()
                                                      .delete(task);
                                                  if (widget.tasks.length ==
                                                      1) {
                                                    widget.projects.remove(
                                                        task.projectName);
                                                    widget.tasks.clear();
                                                  }
                                                }

                                                Navigator.pop(context);
                                              },
                                              child: const Text('بله'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('خیر'),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: const Icon(
                                CupertinoIcons.trash,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void deleteProjectName(TaskEntity task) {
    if (task.projectName.isNotEmpty) {
      final pTasks = widget.tasks
          .where((element) => element.projectName == task.projectName)
          .toList();
      if (pTasks.length == 1) {
        widget.projects.remove(task.projectName);
      }
    }
  }

  void deleteTagName(TaskEntity task) {
    if (task.tag.isNotEmpty) {
      final tagTasks = widget.tasks.where((element) => element.tag == task.tag);
      if (tagTasks.length == 1) {
        tags.remove(task.tag);
        selectedTag = '';
      }
    }
  }
}
