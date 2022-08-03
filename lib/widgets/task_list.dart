import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.tasks,
    required this.theme,
    required this.bloc,
    required this.scaffoldKey,
  }) : super(key: key);

  final List<TaskEntity> tasks;
  final ThemeData theme;
  final HomeBloc? bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 55),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemExtent: 85,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          bool? checked = task.checked;
          return Stack(
            children: [
              Visibility(
                visible: task.important,
                child: Container(
                  height: 64,
                  margin: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                  decoration: BoxDecoration(
                      color: checked ? null : Colors.red,
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
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(36))),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(36),
                                  ),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        task.important
                                            ? CupertinoIcons.flag_fill
                                            : CupertinoIcons.flag,
                                        size: 18,
                                        color: task.important
                                            ? Colors.red
                                            : MyApp.primaryTextColor,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: TextStyle(
                                              decoration: checked
                                                  ? TextDecoration.lineThrough
                                                  : null),
                                        ),
                                      ),
                                      Checkbox(
                                          side: BorderSide(
                                              color:
                                                  theme.colorScheme.secondary,
                                              width: 2),
                                          activeColor:
                                              theme.colorScheme.secondary,
                                          value: checked,
                                          onChanged: (value) {
                                            setState(() {
                                              task.checked = value!;
                                              bloc!.add(CheckedClicked(task));
                                            });
                                          })
                                    ],
                                  ),
                                  Visibility(
                                    visible: task.tag.isNotEmpty,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: Colors.grey.shade200),
                                      child: Text(
                                        task.tag,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(task.content)
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  height: 65,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                  margin:
                      EdgeInsets.fromLTRB(32, 8, task.important ? 36 : 32, 8),
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
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            task.important
                                ? CupertinoIcons.flag_fill
                                : CupertinoIcons.flag,
                            size: 18,
                            color: task.important
                                ? Colors.red
                                : MyApp.primaryTextColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                  decoration: checked
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                          ),
                          Checkbox(
                              side: BorderSide(
                                  color: theme.colorScheme.secondary, width: 2),
                              activeColor: theme.colorScheme.secondary,
                              value: checked,
                              onChanged: (value) {
                                task.checked = value!;
                                bloc!.add(CheckedClicked(task));
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
