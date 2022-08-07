import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';
import 'package:easy_task/ui/bottom_sheet/botttom_sheet.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.tasks,
    required this.theme,
    required this.bloc,
    required this.projects,
  }) : super(key: key);

  final List<TaskEntity> tasks;
  final ThemeData theme;
  final Bloc? bloc;
  final List<String> projects;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemExtent: 90,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
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
                            projects: projects,
                            task: task,
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
                          theme: theme,
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
                          ? theme.colorScheme.secondary.withOpacity(0.2)
                          : Colors.white,
                      border: checked
                          ? Border.all(
                              color:
                                  theme.colorScheme.secondary.withOpacity(0.2))
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
                              if (bloc is HomeBloc) {
                                bloc?.add(UpdateTask(task));
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
                                  color: theme.colorScheme.secondary, width: 2),
                              activeColor: theme.colorScheme.secondary,
                              value: checked,
                              onChanged: (value) {
                                task.checked = value!;
                                if (bloc is HomeBloc && bloc != null) {
                                  bloc?.add(UpdateTask(task));
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
                                style: theme.textTheme.bodyText1!
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
                                            style: theme.textTheme.headline4,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                if (bloc is HomeBloc) {
                                                  bloc?.add(DeleteTask(task));
                                                } else {
                                                  getIt<TaskRepository>()
                                                      .delete(task);
                                                }
                                              },
                                              child: Text('بله'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('خیر'),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
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
}
