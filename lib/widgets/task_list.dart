import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool? checked = false;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 55),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemExtent: 85,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                height: 64,
                margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
                decoration: BoxDecoration(
                    color: checked! ? null : Colors.red,
                    borderRadius: BorderRadius.circular(12)),
              ),
              Container(
                height: 64,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                margin: EdgeInsets.fromLTRB(32, 8, !checked! ? 36 : 32, 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: checked!
                        ? widget.theme.colorScheme.secondary.withOpacity(0.2)
                        : Colors.white,
                    boxShadow: !checked!
                        ? [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5)
                          ]
                        : null,
                    border: checked!
                        ? Border.all(
                            color: widget.theme.colorScheme.secondary
                                .withOpacity(0.2))
                        : null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'انجام تکالیف',
                      style: TextStyle(
                          decoration:
                              checked! ? TextDecoration.lineThrough : null),
                    ),
                    Checkbox(
                        activeColor: widget.theme.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: widget.theme.colorScheme.secondary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        value: checked,
                        onChanged: (value) {
                          setState(() {
                            checked = value;
                          });
                        })
                  ],
                ),
              ),
            ],
          );
        });
  }
}
