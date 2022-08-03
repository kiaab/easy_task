import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';

import 'package:easy_task/ui/bottom_sheet/bloc/task_bottom_sheet_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBottomSheet extends StatelessWidget {
  const TaskBottomSheet({
    Key? key,
    required this.checked,
    required this.theme,
    required this.taskId,
  }) : super(key: key);

  final bool? checked;
  final ThemeData theme;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBottomSheetBloc>(
      create: (context) => TaskBottomSheetBloc(getIt<TaskRepository>())
        ..add(TaskBottomSheetStarted(taskId)),
      child: BlocBuilder<TaskBottomSheetBloc, TaskBottomSheetState>(
        builder: (context, state) {
          if (state is TaskBottomSheetSuccess) {
            final task = state.task;
            return Directionality(
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
                                decoration: checked!
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
                              BlocProvider.of<TaskBottomSheetBloc>(context)
                                  .add(TaskBottomSheetCheckedClicked(task));
                            })
                      ],
                    ),
                    Visibility(
                      visible: task.tag.isNotEmpty,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
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
            );
          } else {
            throw Exception('invalid state');
          }
        },
      ),
    );
  }
}
