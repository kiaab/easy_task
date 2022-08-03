import 'package:easy_task/data/repo/task_repo.dart';
import 'package:easy_task/data/task.dart';
import 'package:easy_task/main.dart';
import 'package:easy_task/ui/add_or_edit/bloc/add_or_edit_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddOrEditScreen extends StatelessWidget {
  const AddOrEditScreen({Key? key, required this.task}) : super(key: key);
  final TaskEntity task;
  @override
  Widget build(BuildContext context) {
    final TextEditingController titleTextController =
        TextEditingController(text: task.title);
    final TextEditingController contentTextController =
        TextEditingController(text: task.content);
    final TextEditingController tagTextController =
        TextEditingController(text: task.tag);
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
                      task.title = titleTextController.text;
                      task.content = contentTextController.text;
                      task.tag = tagTextController.text;

                      task.important = _important!;
                      BlocProvider.of<AddOrEditBloc>(context)
                          .add(SaveButtonClicked(task));
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
                      padding: const EdgeInsets.fromLTRB(28, 16, 28, 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
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
                            controller: tagTextController,
                            decoration: InputDecoration(
                              hintText:
                                  ' برچسب : با برچسب تسکاتو راحتر پیدا کن',
                              hintStyle: theme.textTheme.bodyText1!.copyWith(
                                  color: MyApp.secondaryTextColor
                                      .withOpacity(0.4)),
                            ),
                          ),
                          Row(
                            children: [
                              ImportantCheckBox(theme: theme),
                              const Text('ضروری')
                            ],
                          ),
                          TextField(
                            controller: contentTextController,
                            decoration: InputDecoration(
                              hintText:
                                  'توضیحات : مثلا امروز باید در جلسه طراحی محصول را توضیح بدم',
                              hintStyle: theme.textTheme.bodyText1!.copyWith(
                                  color: MyApp.secondaryTextColor
                                      .withOpacity(0.4)),
                            ),
                          ),
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

bool? _important = false;

class ImportantCheckBox extends StatefulWidget {
  const ImportantCheckBox({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  State<ImportantCheckBox> createState() => _ImportantCheckBoxState();
}

class _ImportantCheckBoxState extends State<ImportantCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        side: BorderSide(color: widget.theme.colorScheme.primary, width: 2),
        activeColor: widget.theme.colorScheme.primary,
        value: _important,
        onChanged: (value) {
          setState(() {
            _important = value;
          });
        });
  }
}
