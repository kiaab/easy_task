import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    Key? key,
    required this.tasks,
    required this.projectNames,
    required this.tags,
  }) : super(key: key);

  final List<TaskEntity> tasks;
  final List<String> projectNames;
  final List<String> tags;

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.tasks[0].projectName),
      ),
      body: ValueListenableBuilder<Box<TaskEntity>>(
        valueListenable: Hive.box<TaskEntity>(taskBoxName).listenable(),
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TaskList(
              tags: widget.tags,
              tasks: widget.tasks,
              theme: Theme.of(context),
              bloc: null,
              projects: widget.projectNames),
        ),
      ),
    );
  }
}
