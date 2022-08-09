import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:easy_task/ui/home/home_screen.dart';
import 'package:flutter/material.dart';

class TagList extends StatelessWidget {
  const TagList({
    Key? key,
    this.tagTextController,
    required this.tags,
    this.bloc,
    this.pickedDate,
  }) : super(key: key);

  final List<String> tags;
  final HomeBloc? bloc;
  final String? pickedDate;
  final TextEditingController? tagTextController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          padding: EdgeInsets.fromLTRB(32, 0, 32, 4),
          itemBuilder: (context, index) {
            final tagName = tags[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                if (tagTextController != null) {
                  tagTextController?.text = tagName;
                } else {
                  selectedTag = tagName;
                  bloc?.add(HomeStarted(pickedDate!));
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(
                    index == tags.length - 1 ? 0 : 8, 4, index == 0 ? 0 : 8, 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade200),
                child: Text(
                  tagName,
                ),
              ),
            );
          }),
    );
  }
}
