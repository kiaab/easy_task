import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/bloc/add_or_edit_bloc.dart';

import 'package:easy_task/widgets/tag_list.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class AddOrEditScreen extends StatefulWidget {
  const AddOrEditScreen({Key? key, required this.task}) : super(key: key);
  final TaskEntity task;

  @override
  State<AddOrEditScreen> createState() => _AddOrEditScreenState();
}

class _AddOrEditScreenState extends State<AddOrEditScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool titleFieldEmpty = false;

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final FocusNode projectFocusNode = FocusNode();

  TextEditingController? projectTextController;
  TextEditingController? tagTextController;
  TextEditingController? contentTextController;
  TextEditingController? titleTextController;
  String picked = '';
  @override
  void initState() {
    picked = widget.task.date;
    WidgetsBinding.instance.addObserver(this);
    titleTextController = TextEditingController(text: widget.task.title);

    contentTextController = TextEditingController(text: widget.task.content);

    tagTextController = TextEditingController(text: widget.task.tag);

    projectTextController =
        TextEditingController(text: widget.task.projectName);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      titleFocusNode.unfocus();
      tagFocusNode.unfocus();
      contentFocusNode.unfocus();
      projectFocusNode.unfocus();
    }
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    titleFocusNode.dispose();
    tagFocusNode.dispose();

    contentFocusNode.dispose();
    projectFocusNode.dispose();
    super.dispose();
  }

  AddOrEditBloc? editBloc;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider<AddOrEditBloc>(
      create: (context) {
        final bloc = AddOrEditBloc(getIt<TaskRepository>())..add(EditStarted());
        editBloc = bloc;
        return bloc;
      },
      child: Theme(
        data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: theme.colorScheme.primary, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary)))),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              onPressed: () {
                if (titleTextController!.text.isNotEmpty) {
                  widget.task.title = titleTextController!.text;
                  widget.task.content = contentTextController!.text;
                  widget.task.tag = tagTextController!.text;
                  widget.task.projectName = projectTextController!.text;
                  widget.task.date = picked;

                  editBloc?.add(Save(widget.task));
                  Navigator.pop(context);
                } else {
                  setState(() {
                    titleFieldEmpty = true;
                  });
                }
              },
              child: Text(
                '??????????',
                style: theme.textTheme.headline4!.copyWith(color: Colors.white),
              ),
            ),
            appBar: AppBar(
              title: const Text('????????????'),
              centerTitle: true,
            ),
            body: BlocBuilder<AddOrEditBloc, AddOrEditState>(
              builder: (context, state) {
                if (state is EditSuccess) {
                  final projects = state.projects;
                  final tags = state.tags;

                  return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 75, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28.0, right: 28),
                              child: TextField(
                                style: theme.textTheme.bodyText2,
                                focusNode: titleFocusNode,
                                maxLength: 40,
                                controller: titleTextController,
                                decoration: titleFieldEmpty
                                    ? InputDecoration(
                                        enabled: true,
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Colors.red, width: 2)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Colors.red)),
                                        errorText: '?????????? ???????????????? ???????? ????????',
                                        hintText: ' ?????????? : ?????????? ???????? ???? ????????',
                                        hintStyle: theme.textTheme.bodyText1!
                                            .copyWith(
                                                color: MyApp.secondaryTextColor
                                                    .withOpacity(0.4)),
                                      )
                                    : InputDecoration(
                                        hintText: ' ?????????? : ?????????? ???????? ???? ????????',
                                        hintStyle: theme.textTheme.bodyText1!
                                            .copyWith(
                                                color: MyApp.secondaryTextColor
                                                    .withOpacity(0.4)),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28.0, right: 28),
                              child: TextField(
                                style: theme.textTheme.bodyText2,
                                focusNode: tagFocusNode,
                                maxLength: 25,
                                controller: tagTextController,
                                decoration: InputDecoration(
                                  hintText:
                                      ' ?????????? : ???? ?????????? ???????????? ?????????? ???????? ????',
                                  hintStyle: theme.textTheme.bodyText1!
                                      .copyWith(
                                          color: MyApp.secondaryTextColor
                                              .withOpacity(0.4)),
                                ),
                              ),
                            ),

                            //Tag list
                            Visibility(
                              visible: tags.isNotEmpty,
                              child: TagList(
                                  tags: tags,
                                  tagTextController: tagTextController),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28.0, right: 16),
                              child: Row(
                                children: [
                                  Checkbox(
                                      side: BorderSide(
                                          color: theme.colorScheme.primary,
                                          width: 2),
                                      activeColor: theme.colorScheme.primary,
                                      value: widget.task.important,
                                      onChanged: (value) {
                                        setState(() {
                                          widget.task.important = value!;
                                        });
                                      }),
                                  const Text('??????????')
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28.0, right: 28),
                              child: TextField(
                                style: theme.textTheme.bodyText2,
                                maxLength: 200,
                                focusNode: contentFocusNode,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                controller: contentTextController,
                                decoration: InputDecoration(
                                  hintText:
                                      '?????????????? : ???????? ?????????? ???????? ???? ???????? ?????????? ?????????? ???? ?????????? ??????',
                                  hintStyle: theme.textTheme.bodyText1!
                                      .copyWith(
                                          color: MyApp.secondaryTextColor
                                              .withOpacity(0.4)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28.0, right: 28),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '???????????? ??????????',
                                      style: theme.textTheme.bodyText1!
                                          .copyWith(fontSize: 16),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () async {
                                        final jalaliPicked =
                                            await showPersianDatePicker(
                                                    context: context,
                                                    initialDate: Jalali.now(),
                                                    firstDate: Jalali(1390),
                                                    lastDate: Jalali(1450)) ??
                                                widget.task.date;
                                        if (jalaliPicked is Jalali) {
                                          picked =
                                              jalaliPicked.formatFullDate();
                                        }

                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: theme
                                                        .colorScheme.primary))),
                                        child: Text(picked),
                                      ),
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28.0, right: 28),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '??????????',
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: theme.colorScheme.primary),
                                        child: const Icon(
                                          CupertinoIcons.plus,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextField(
                                    style: theme.textTheme.bodyText2,
                                    focusNode: projectFocusNode,
                                    maxLength: 35,
                                    controller: projectTextController,
                                    decoration: InputDecoration(
                                      hintText: ' ?????????? :',
                                      hintStyle: theme.textTheme.bodyText1!
                                          .copyWith(
                                              color: MyApp.secondaryTextColor
                                                  .withOpacity(0.4)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: projects.isNotEmpty,
                              child: SizedBox(
                                height: 50,
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                      left: 28,
                                      right: 28,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: projects.length,
                                    itemBuilder: (context, index) {
                                      final projectName = projects[index];
                                      return InkWell(
                                        borderRadius: BorderRadius.circular(18),
                                        onTap: () {
                                          projectTextController!.text =
                                              projectName;
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: EdgeInsets.fromLTRB(
                                              index == projects.length - 1
                                                  ? 0
                                                  : 8,
                                              8,
                                              index == 0 ? 0 : 8,
                                              4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: Colors.grey.shade200),
                                          child: Text(
                                            projectName,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ));
                } else if (state is AddOrEditInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  throw Exception('invalid state');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
