import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';

import 'package:easy_task/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    Key? key,
    required this.projectName,
  }) : super(key: key);

  final String projectName;

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.projectName),
      ),
      body: ValueListenableBuilder<Box<TaskEntity>>(
          valueListenable: Hive.box<TaskEntity>(taskBoxName).listenable(),
          builder: (context, box, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TaskList(
                tasks: box.values
                    .toList()
                    .where(
                        (element) => element.projectName == widget.projectName)
                    .toList(),
                theme: Theme.of(context),
              ),
            );
          }),
    );
  }
}
