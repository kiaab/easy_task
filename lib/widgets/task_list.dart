import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';
import 'package:easy_task/ui/bottom_sheet/botttom_sheet.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    Key? key,
    required this.tasks,
    required this.theme,
  }) : super(key: key);

  final List<TaskEntity> tasks;
  final ThemeData theme;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;
    final theme = widget.theme;
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 75),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemExtent: 90,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          for (var element in tasks) {
            if (element.important == true) {
              tasks.remove(element);
              tasks.insert(0, element);
            }
          }

          final task = tasks[index];
          bool? checked = task.checked;
          return Stack(
            children: [
              Visibility(
                visible: task.important,
                child: AnimatedContainer(
                  curve: Curves.linear,
                  duration: const Duration(milliseconds: 350),
                  height: 90,
                  margin: const EdgeInsets.fromLTRB(32, 4, 32, 4),
                  decoration: BoxDecoration(
                      color: checked ? Colors.white : Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              GestureDetector(
                onLongPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddOrEditScreen(
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
                child: AnimatedContainer(
                  curve: Curves.linear,
                  duration: const Duration(milliseconds: 350),
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

                              getIt<HomeBloc>().add(AddOrUpdateTask(task));
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
                              value: task.checked,
                              onChanged: (value) {
                                task.checked = value!;

                                getIt<HomeBloc>().add(AddOrUpdateTask(task));
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
                                                getIt<HomeBloc>()
                                                    .add(DeleteTask(task));

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
}
