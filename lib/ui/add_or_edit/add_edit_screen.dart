import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/bloc/add_or_edit_bloc.dart';

import 'package:easy_task/utils.dart';
import 'package:easy_task/widgets/tag_list.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class AddOrEditScreen extends StatefulWidget {
  const AddOrEditScreen(
      {Key? key,
      required this.task,
      required this.projects,
      required this.tags})
      : super(key: key);
  final TaskEntity task;
  final List<String> projects;
  final List<String> tags;

  @override
  State<AddOrEditScreen> createState() => _AddOrEditScreenState();
}

class _AddOrEditScreenState extends State<AddOrEditScreen>
    with WidgetsBindingObserver {
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final FocusNode projectFocusNode = FocusNode();

  String picked = '';
  @override
  void initState() {
    picked = widget.task.date;
    WidgetsBinding.instance.addObserver(this);
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

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleTextController =
        TextEditingController(text: widget.task.title);

    final TextEditingController contentTextController =
        TextEditingController(text: widget.task.content);

    final TextEditingController tagTextController =
        TextEditingController(text: widget.task.tag);

    final TextEditingController projectTextController =
        TextEditingController(text: widget.task.projectName);

    final ThemeData theme = Theme.of(context);
    return Theme(
      data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary)))),
      child: BlocProvider<AddOrEditBloc>(
        create: (context) {
          final bloc = AddOrEditBloc(getIt<TaskRepository>());
          return bloc;
        },
        child: BlocBuilder<AddOrEditBloc, AddOrEditState>(
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton(
                  backgroundColor: theme.colorScheme.primary,
                  onPressed: () {
                    if (titleTextController.text.isNotEmpty) {
                      widget.task.title = titleTextController.text;
                      widget.task.content = contentTextController.text;
                      widget.task.tag = tagTextController.text;
                      widget.task.projectName = projectTextController.text;
                      widget.task.date = picked;
                      checkedProjectIsInListAndAdd(projectTextController.text);
                      checkedTagIsInListAndAdd(tagTextController.text);
                      BlocProvider.of<AddOrEditBloc>(context)
                          .add(SaveButtonClicked(widget.task));
                      Navigator.pop(context);
                    } else {
                      BlocProvider.of<AddOrEditBloc>(context)
                          .add(TitleFieldIsEmpty());
                    }
                  },
                  child: Text(
                    'ذخیره',
                    style: theme.textTheme.headline4!
                        .copyWith(color: Colors.white),
                  ),
                ),
                appBar: AppBar(
                  title: const Text('ویرایش'),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 16, 28, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            focusNode: titleFocusNode,
                            maxLength: 40,
                            controller: titleTextController,
                            decoration: state is AddOrEditError
                                ? InputDecoration(
                                    enabled: true,
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.red)),
                                    errorText: 'عنوان نمیتواند خالی باشد',
                                    hintText: ' عنوان : مثالا شرکت در جلسه',
                                    hintStyle: theme.textTheme.bodyText1!
                                        .copyWith(
                                            color: MyApp.secondaryTextColor
                                                .withOpacity(0.4)),
                                  )
                                : InputDecoration(
                                    hintText: ' عنوان : مثالا شرکت در جلسه',
                                    hintStyle: theme.textTheme.bodyText1!
                                        .copyWith(
                                            color: MyApp.secondaryTextColor
                                                .withOpacity(0.4)),
                                  ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextField(
                            focusNode: tagFocusNode,
                            maxLength: 25,
                            controller: tagTextController,
                            decoration: InputDecoration(
                              hintText:
                                  ' برچسب : با برچسب تسکاتو راحتر پیدا کن',
                              hintStyle: theme.textTheme.bodyText1!.copyWith(
                                  color: MyApp.secondaryTextColor
                                      .withOpacity(0.4)),
                            ),
                          ),

                          //Tag list
                          TagList(
                              tags: widget.tags,
                              tagTextController: tagTextController),

                          Row(
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
                              const Text('ضروری')
                            ],
                          ),
                          TextField(
                            focusNode: contentFocusNode,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            controller: contentTextController,
                            decoration: InputDecoration(
                              hintText:
                                  'توضیحات : مثلا امروز باید در جلسه طراحی محصول را توضیح بدم',
                              hintStyle: theme.textTheme.bodyText1!.copyWith(
                                  color: MyApp.secondaryTextColor
                                      .withOpacity(0.4)),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'انتخاب تاریخ',
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
                                      picked = jalaliPicked.formatFullDate();
                                    }

                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: theme
                                                    .colorScheme.primary))),
                                    child: Text(picked),
                                  ),
                                ),
                              ]),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'پروژه',
                                    style: theme.textTheme.bodyText1!
                                        .copyWith(fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.colorScheme.primary),
                                    child: Icon(
                                      CupertinoIcons.plus,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextField(
                                focusNode: projectFocusNode,
                                maxLength: 35,
                                controller: projectTextController,
                                decoration: InputDecoration(
                                  hintText: ' پروژه :',
                                  hintStyle: theme.textTheme.bodyText1!
                                      .copyWith(
                                          color: MyApp.secondaryTextColor
                                              .withOpacity(0.4)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.projects.length,
                                itemBuilder: (context, index) {
                                  final projectName = widget.projects[index];
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () {
                                      projectTextController.text = projectName;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.all(8),
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
                          )
                        ],
                      ),
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
