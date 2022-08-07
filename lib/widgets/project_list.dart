import 'package:easy_task/data/task.dart';
import 'package:easy_task/ui/project/project.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProjecList extends StatelessWidget {
  const ProjecList({
    Key? key,
    required this.theme,
    required this.projects,
    required this.tasks,
  }) : super(key: key);

  final ThemeData theme;
  final List<String> projects;
  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 10),
          scrollDirection: Axis.horizontal,
          itemCount: projects.length,
          itemBuilder: (contex, index) {
            final projectTasks = tasks
                .where((element) => element.projectName == projects[index])
                .toList();
            final int total = projectTasks.length;

            int done = 0;
            for (var e in projectTasks) {
              if (e.checked == true) {
                done++;
              }
            }
            final int unDone = total - done;
            final projectName = projects[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (contex) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: ProjectScreen(
                        tasks: projectTasks,
                        projectNames: projects,
                      )))),
              child: Stack(
                children: [
                  Positioned.fill(
                    bottom: 6,
                    top: 60,
                    left: 28,
                    right: 28,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.4),
                              blurRadius: 10)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
                    width: 200,
                    height: 160,
                    margin: EdgeInsets.fromLTRB(
                        index == 1 ? 0 : 8, 12, index == 0 ? 0 : 8, 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projectName,
                          style: theme.textTheme.headline4!
                              .copyWith(fontSize: 14, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'انجام شده : $done',
                          style: theme.textTheme.caption,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'باقی مانده : $unDone',
                          style: theme.textTheme.caption,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        LinearPercentIndicator(
                          barRadius: const Radius.circular(12),
                          padding: EdgeInsets.zero,
                          percent: done / total,
                          progressColor: theme.colorScheme.secondary,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'پیشرفت',
                              style: theme.textTheme.caption,
                            ),
                            Text(
                              '${((done / total) * 100).toInt()}%',
                              style: theme.textTheme.caption,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
