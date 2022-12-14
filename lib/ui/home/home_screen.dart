import 'dart:async';

import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';

import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';

import 'package:easy_task/ui/home/bloc/home_bloc.dart';

import 'package:easy_task/widgets/error_state.dart';
import 'package:easy_task/widgets/project_list.dart';
import 'package:easy_task/widgets/search_bar.dart';
import 'package:easy_task/widgets/search_icon.dart';

import 'package:easy_task/widgets/task_list.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';

final ScrollController homeScrollController = ScrollController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  Jalali picked = Jalali.now();
  String selectedTag = '';
  HomeBloc? _homeBloc;
  late AnimationController _animationController;
  late Animation<double> searchAnimation;

  @override
  void dispose() {
    _homeBloc?.close();
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      focusNode.unfocus();
    }
    super.didChangeMetrics();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    searchAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    WidgetsBinding.instance.addObserver(this);
    Hive.box<TaskEntity>(taskBoxName).listenable().addListener(() {
      _homeBloc?.add(HomeStarted());
    });
    _animationController.forward();
    super.initState();
  }

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return BlocProvider<HomeBloc>(
      create: (context) {
        final bloc = HomeBloc(taskRepository: getIt<TaskRepository>());
        bloc.add(HomeStarted());
        GetIt.I.registerSingleton(bloc);

        _homeBloc = bloc;
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            ' ???????? ????????',
          ),
          leading: Padding(
            padding: const EdgeInsets.only(right: 32),
            child: SizedBox(
              width: 20,
              child: GestureDetector(
                  onTap: () {
                    if (homeScrollController.hasClients) {
                      homeScrollController.animateTo(0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.decelerate);
                      Timer(const Duration(seconds: 1), () {
                        focusNode.requestFocus();
                      });
                    }
                  },
                  child: const SearchIcon()),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: InkWell(
                  onTap: () {
                    showMenu(
                        context: context,
                        position: RelativeRect.fill,
                        items: [
                          PopupMenuItem(
                            onTap: () {
                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: Text(
                                              '?????? ???? ?????? ?????? ?????????? ??????????',
                                              style: theme.textTheme.headline4,
                                            ),
                                            content: const Text(
                                                '???? ?????? ?????????? ???????? ?????? ???? ?? ?????????? ?????? ?????? ?????? ?????????? ???? '),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  _homeBloc?.add(DeleteAll());

                                                  Navigator.pop(context);
                                                },
                                                child: const Text('??????'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('??????'),
                                              )
                                            ],
                                          ),
                                        );
                                      }));
                            },
                            child: Row(
                              children: const [
                                Icon(CupertinoIcons.delete),
                                SizedBox(width: 32),
                                Text('?????? ??????')
                              ],
                            ),
                          )
                        ]);
                  },
                  child: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                  )),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.colorScheme.primary,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddOrEditScreen(
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
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccess) {
              List<TaskEntity> tasks = state.tasks;
              final projects = state.projects;

              final tags = state.tags;

              //tasks for current date

              if (selectedTag.isEmpty) {
                tasks = tasks
                    .where((element) => element.date == picked.formatFullDate())
                    .toList();
              } else {
                tasks = tasks
                    .where((element) => element.tag == selectedTag)
                    .toList();
              }

              final taskLength = tasks.length.toString();
              //get project name and save in list

              final projectLenght = projects.length.toString();

              return SingleChildScrollView(
                controller: homeScrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.22,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) => Stack(
                          children: [
                            Container(
                              height: size.height * 0.22 - 26,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(48)),
                              ),
                            ),
                            Positioned(
                              top: -25 * (1 - _animationController.value),
                              height: 50,
                              child: Opacity(
                                opacity: _animationController.value,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 32, left: 32),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: name.isNotEmpty,
                                        child: Text(
                                          '???????? $name',
                                          style: theme.textTheme.headline6!
                                              .copyWith(
                                                  fontSize: 22,
                                                  color: Colors.white),
                                          maxLines: 1,
                                        ),
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
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: 50 * (1 - _animationController.value),
                              child: Opacity(
                                opacity: _animationController.value,
                                child: SearchBar(
                                  focusNode: focusNode,
                                  theme: theme,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) => Stack(
                        children: [
                          Opacity(
                            opacity: _animationController.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 28,
                                ),
                                Visibility(
                                  visible: projects.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 32, left: 32),
                                    child: RichText(
                                        text: TextSpan(
                                            style: theme.textTheme.headline4,
                                            text: '?????????? ????',
                                            children: [
                                          TextSpan(
                                              text: ' ($projectLenght)',
                                              style: theme.textTheme.headline4!
                                                  .copyWith(
                                                      color: MyApp
                                                          .primaryTextColor))
                                        ])),
                                  ),
                                ),
                                Visibility(
                                  visible: projects.isNotEmpty,
                                  child: ProjectList(
                                    projects: projects,
                                    theme: theme,
                                    homeBloc: _homeBloc,
                                    tasks: state.tasks,
                                  ),
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
                                              text: '?????? ????',
                                              children: [
                                            TextSpan(
                                                text: ' ($taskLength)',
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
                                          _homeBloc?.add(HomeStarted());
                                        },
                                        child: Text(picked.formatFullDate()),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: tags.isNotEmpty,
                                    child: SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: tags.length,
                                          padding: const EdgeInsets.fromLTRB(
                                              32, 0, 32, 4),
                                          itemBuilder: (context, index) {
                                            final tagName = tags[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedTag == tagName
                                                      ? selectedTag = ''
                                                      : selectedTag = tagName;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                curve: Curves.bounceInOut,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin: EdgeInsets.fromLTRB(
                                                    index == tags.length - 1
                                                        ? 0
                                                        : 8,
                                                    0,
                                                    index == 0 ? 0 : 8,
                                                    4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    color: selectedTag ==
                                                            tagName
                                                        ? Colors.grey.shade300
                                                        : Colors.grey.shade50),
                                                child: Text(
                                                  tagName,
                                                ),
                                              ),
                                            );
                                          }),
                                    )),
                                TaskList(tasks: tasks, theme: theme),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/no_data.svg',
                      width: 130,
                      height: 130,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      '???????? ???????? ????????????',
                      style: theme.textTheme.bodyText1!.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () async {
                        picked = await showPersianDatePicker(
                                initialEntryMode: DatePickerEntryMode.calendar,
                                context: context,
                                initialDate: Jalali.now(),
                                firstDate: Jalali(1390),
                                lastDate: Jalali(1450)) ??
                            picked;
                        _homeBloc?.add(HomeStarted());
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: theme.colorScheme.primary))),
                          child: Text(picked.formatFullDate())),
                    ),
                  ],
                ),
              );
            } else {
              throw Exception('invalid state');
            }
          },
        ),
      ),
    );
  }
}
