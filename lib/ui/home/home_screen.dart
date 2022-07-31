import 'dart:async';

import 'package:easy_task/main.dart';
import 'package:easy_task/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final ScrollController controller = ScrollController();

class _HomeScreenState extends State<HomeScreen> {
  bool? checked = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'تسک ها',
              style: theme.textTheme.headline6!.copyWith(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(left: 32),
              child: SearchIcon(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.colorScheme.primary,
          onPressed: () {},
          child: const Icon(
            CupertinoIcons.plus,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              Container(
                  height: size.height * 0.22,
                  child: Stack(
                    children: [
                      Container(
                        height: size.height * 0.22 - 26,
                        decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(48))),
                      ),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'سلام کیا',
                                style: theme.textTheme.bodyText2!.copyWith(
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  'امروز 5 تسک برای انجام دادن داری',
                                  maxLines: 2,
                                  style: theme.textTheme.headline6!.copyWith(
                                      color: Colors.white,
                                      fontSize: 20,
                                      height: 1.2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: SearchBar(
                            theme: theme,
                          ))
                    ],
                  )),
              Container(
                child: Stack(
                  children: [Body(theme: theme, checked: checked)],
                ),
              )
            ],
          ),
        ));
  }
}

class Body extends StatelessWidget {
  const Body({Key? key, required this.theme, required this.checked})
      : super(key: key);
  final ThemeData theme;
  final bool? checked;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 28,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 32),
          child: RichText(
              text: TextSpan(
                  style: theme.textTheme.headline4,
                  text: 'پروژه ها',
                  children: [
                TextSpan(
                    text: '(2)',
                    style: theme.textTheme.headline4!
                        .copyWith(color: MyApp.primaryTextColor))
              ])),
        ),
        ProjecList(theme: theme),
        Padding(
          padding: const EdgeInsets.only(right: 32, top: 8),
          child: Text(
            'تسک ها',
            style: theme.textTheme.headline4,
          ),
        ),
        TaskList(theme: theme)
      ],
    );
  }
}

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

class ProjecList extends StatelessWidget {
  const ProjecList({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 10),
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (contex, index) {
            return Stack(
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
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  width: 200,
                  height: 140,
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
                        'پروژه اندروید',
                        style: theme.textTheme.headline4!
                            .copyWith(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'تسک های انجام شده :',
                        style: theme.textTheme.caption,
                      ),
                      Text(
                        'تسک های باقی مانده :',
                        style: theme.textTheme.caption,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      LinearPercentIndicator(
                        barRadius: const Radius.circular(12),
                        padding: EdgeInsets.zero,
                        percent: 0.5,
                        progressColor: theme.colorScheme.secondary,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'پیشرفت',
                            style: theme.textTheme.caption,
                          ),
                          Text(
                            '20%',
                            style: theme.textTheme.caption,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class SearchIcon extends StatefulWidget {
  const SearchIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchIcon> createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  bool isshowSearch(BuildContext context) {
    final scrollPosition = controller.offset;
    if (scrollPosition > (MediaQuery.of(context).size.height * 0.2)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    controller.addListener(
      () {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: Duration(milliseconds: 80),
      scale: isshowSearch(context) ? 2 : 0,
      child: Visibility(
        visible: isshowSearch(context),
        child: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(';d;d')));
          },
          child: const Icon(
            CupertinoIcons.search,
            color: Colors.white,
            size: 12,
          ),
        ),
      ),
    );
  }
}
