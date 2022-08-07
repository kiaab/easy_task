import 'package:easy_task/data/data_source/project_source.dart';
import 'package:easy_task/data/data_source/task_source.dart';
import 'package:easy_task/data/projec/project.dart';
import 'package:easy_task/data/repo/project_repo.dart';
import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';

import 'package:easy_task/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

const taskBoxName = 'taskBox';
const projectBoxName = 'projectBox';
final GetIt getIt = GetIt.instance;
void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ProjectAdapter());

  await Hive.openBox<ProjectEntity>(projectBoxName);
  await Hive.openBox<TaskEntity>(taskBoxName);

  getIt.registerSingleton(
      ProjectDataSource(Hive.box<ProjectEntity>(projectBoxName)));
  getIt.registerSingleton(ProjectRepository(getIt<ProjectDataSource>()));

  getIt.registerSingleton(TaskDataSource(Hive.box<TaskEntity>(taskBoxName)));
  getIt.registerSingleton(TaskRepository(getIt<TaskDataSource>()));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const fontFamily = 'Yekan';
  static const primaryTextColor = Color(0xff273067);
  static final secondaryTextColor = Color(0xff273067).withOpacity(0.3);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyText2: TextStyle(
                fontFamily: MyApp.fontFamily, color: MyApp.primaryTextColor),
            headline6: TextStyle(
                fontFamily: MyApp.fontFamily,
                fontSize: 18,
                color: MyApp.secondaryTextColor,
                fontWeight: FontWeight.bold),
            headline4: TextStyle(
                fontFamily: MyApp.fontFamily,
                fontSize: 16,
                color: MyApp.secondaryTextColor),
            bodyText1: TextStyle(
                fontFamily: MyApp.fontFamily,
                color: MyApp.secondaryTextColor,
                fontSize: 12),
            caption: const TextStyle(
                fontFamily: MyApp.fontFamily,
                color: Colors.white,
                fontSize: 10),
          ),
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF0d12d7),
              onSurface: Color(0xFFECEEEC),
              secondary: Color(0xffffa200))),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: HomeScreen()),
    );
  }

  @override
  void dispose() async {
    Hive.box<TaskEntity>(taskBoxName).close();
    super.dispose();
  }
}
