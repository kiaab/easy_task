import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

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
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 12),
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
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
                const SizedBox(
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200),
                child: Text(
                  widget.task.tag,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(child: Text(widget.task.content)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddOrEditScreen(task: widget.task))),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: Text(
                                'انتقال تسک به تاریخ فعلی ؟',
                                style: widget.theme.textTheme.headline4,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    widget.task.date =
                                        Jalali.now().formatFullDate();
                                    getIt<TaskRepository>()
                                        .addOrUpdate(widget.task);
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
                  child: Icon(
                    CupertinoIcons.arrowshape_turn_up_left,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
