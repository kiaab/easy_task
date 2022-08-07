import 'dart:async';
import 'dart:math';

import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:easy_task/ui/project/project.dart';
import 'package:easy_task/widgets/error_state.dart';
import 'package:easy_task/widgets/project_list.dart';
import 'package:easy_task/widgets/search_bar.dart';
import 'package:easy_task/widgets/search_icon.dart';
import 'package:easy_task/widgets/task_list.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

final ScrollController homeScrollController = ScrollController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Jalali picked = Jalali.now();

  HomeBloc? _homeBloc;
  @override
  void dispose() {
    boxListener.removeListener(() {});
    _homeBloc?.close();
    super.dispose();
  }

  final boxListener = Hive.box<TaskEntity>(taskBoxName).listenable();

  @override
  void initState() {
    boxListener.addListener(() {
      _homeBloc!.add(HomeStarted(picked.formatFullDate()));
    });
    super.initState();
  }

  final FocusNode focusNode = FocusNode();
  List<String> projects = [];
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (focusNode.hasFocus) {
          focusNode.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              ' صفحه اصلی',
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: SizedBox(
                  width: 20,
                  child: GestureDetector(
                      onTap: () {
                        if (homeScrollController.hasClients) {
                          homeScrollController.animateTo(0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate);
                          Timer(Duration(seconds: 1), () {
                            focusNode.requestFocus();
                          });
                        }
                      },
                      child: const SearchIcon()),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: theme.colorScheme.primary,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddOrEditScreen(
                    projects: projects,
                    task: TaskEntity(date: picked.formatFullDate()),
                  ),
                ),
              );
            },
            child: const Icon(
              CupertinoIcons.plus,
              color: Colors.white,
            ),
          ),
          body: BlocProvider<HomeBloc>(
            create: (context) {
              final bloc = HomeBloc(taskRepository: getIt<TaskRepository>());
              bloc.add(HomeStarted(picked.formatFullDate()));
              _homeBloc = bloc;
              return bloc;
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeSuccess) {
                  final tasks = state.tasks
                      .where(
                          (element) => element.date == picked.formatFullDate())
                      .toList();
                  final taskLenght = tasks.length.toString();

                  if (projects.isEmpty) {
                    for (var e in state.tasks) {
                      if (e.projectName.isNotEmpty &&
                          !projects.contains(e.projectName)) {
                        projects.add(e.projectName);
                      }
                    }
                  }
                  final projectLenght = projects.length.toString();
                  return SingleChildScrollView(
                    controller: homeScrollController,
                    child: Column(
                      children: [
                        SizedBox(
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
                                    padding: const EdgeInsets.only(
                                        right: 32, left: 32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'سلام کیا',
                                          style: theme.textTheme.headline6!
                                              .copyWith(
                                                  fontSize: 22,
                                                  color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          Jalali.now().formatFullDate(),
                                          style: theme.textTheme.headline6!
                                              .copyWith(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  fontSize: 12,
                                                  height: 1.2),
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
                                      focusNode: focusNode,
                                      bloc: _homeBloc!,
                                      theme: theme,
                                      date: picked.formatFullDate(),
                                    ))
                              ],
                            )),
                        Stack(
                          children: [
                            Column(
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
                                            text: ' ($projectLenght)',
                                            style: theme.textTheme.headline4!
                                                .copyWith(
                                                    color:
                                                        MyApp.primaryTextColor))
                                      ])),
                                ),
                                ProjecList(
                                  tasks: state.tasks,
                                  theme: theme,
                                  projects: projects,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 32, top: 8, left: 32, bottom: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              style: theme.textTheme.headline4,
                                              text: 'تسک ها',
                                              children: [
                                            TextSpan(
                                                text: ' ($taskLenght)',
                                                style: theme
                                                    .textTheme.headline4!
                                                    .copyWith(
                                                        color: MyApp
                                                            .primaryTextColor))
                                          ])),
                                      InkWell(
                                        onTap: () async {
                                          picked = await showPersianDatePicker(
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendar,
                                                  context: context,
                                                  initialDate: Jalali.now(),
                                                  firstDate: Jalali(1390),
                                                  lastDate: Jalali(1450)) ??
                                              picked;
                                          _homeBloc?.add(HomeStarted(
                                              picked.formatFullDate()));
                                        },
                                        child: Text(picked.formatFullDate()),
                                      ),
                                    ],
                                  ),
                                ),
                                TaskList(
                                  projects: projects,
                                  tasks: tasks,
                                  theme: theme,
                                  bloc: _homeBloc,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                } else if (state is HomeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HomeError) {
                  return const ErrorState();
                } else if (state is EmptyState) {
                  return const Center(
                    child: Text('هنوز تسکی نساختی'),
                  );
                } else {
                  throw Exception('invalid state');
                }
              },
            ),
          )),
    );
  }
}
