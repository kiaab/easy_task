import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({
    Key? key,
    required this.theme,
    required this.task,
  }) : super(key: key);
  final TaskEntity task;
  final ThemeData theme;

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  @override
  Widget build(BuildContext context) {
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
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.task.important = !widget.task.important;
                      getIt<TaskRepository>().addOrUpdate(widget.task);
                    });
                  },
                  child: Icon(
                    widget.task.important
                        ? CupertinoIcons.flag_fill
                        : CupertinoIcons.flag,
                    size: 18,
                    color: widget.task.important
                        ? Colors.red
                        : MyApp.primaryTextColor,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: TextStyle(
                        decoration: widget.task.checked
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                ),
                Checkbox(
                    side: BorderSide(
                        color: widget.theme.colorScheme.secondary, width: 2),
                    activeColor: widget.theme.colorScheme.secondary,
                    value: widget.task.checked,
                    onChanged: (value) {
                      setState(() {
                        widget.task.checked = value!;
                      });
                      getIt<TaskRepository>().addOrUpdate(widget.task);
                    })
              ],
            ),
            Visibility(
              visible: widget.task.tag.isNotEmpty,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200),
                child: Text(
                  widget.task.tag,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(widget.task.content),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  CupertinoIcons.trash,
                  color: Colors.red,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
