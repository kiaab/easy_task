import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/add_edit_screen.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:easy_task/widgets/error_state.dart';
import 'package:easy_task/widgets/search_bar.dart';
import 'package:easy_task/widgets/search_icon.dart';
import 'package:easy_task/widgets/task_list.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

final ScrollController homeScreenController = ScrollController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? checked = false;
  @override
  void dispose() {
    boxListener.removeListener(() {});
    bloc?.close();
    super.dispose();
  }

  final boxListener = Hive.box<TaskEntity>(taskBoxName).listenable();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  HomeBloc? bloc;
  @override
  void initState() {
    boxListener.addListener(() {
      bloc!.add(HomeStarted());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            ' صفحه اصلی',
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
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddOrEditScreen(
                  task: TaskEntity(),
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
            bloc.add(HomeStarted());
            this.bloc = bloc;
            return bloc;
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                final tasks = state.tasks;
                return SingleChildScrollView(
                  controller: homeScreenController,
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
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        '12/5/1401 ',
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
                                    bloc: bloc!,
                                    theme: theme,
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
                                          text: '(2)',
                                          style: theme.textTheme.headline4!
                                              .copyWith(
                                                  color:
                                                      MyApp.primaryTextColor))
                                    ])),
                              ),
                              ProjecList(theme: theme),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 32, top: 8),
                                child: RichText(
                                    text: TextSpan(
                                        style: theme.textTheme.headline4,
                                        text: 'تسک ها',
                                        children: [
                                      TextSpan(
                                          text: '(5)',
                                          style: theme.textTheme.headline4!
                                              .copyWith(
                                                  color:
                                                      MyApp.primaryTextColor))
                                    ])),
                              ),
                              TaskList(
                                tasks: tasks,
                                theme: theme,
                                bloc: bloc,
                                scaffoldKey: scaffoldKey,
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
        ));
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
