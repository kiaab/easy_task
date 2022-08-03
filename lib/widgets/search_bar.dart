import 'package:easy_task/main.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.theme,
    required this.bloc,
    required this.focusNode,
  }) : super(key: key);

  final ThemeData theme;
  final HomeBloc? bloc;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController =
        TextEditingController(text: '');
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Container(
        height: 52,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: 20, color: theme.colorScheme.primary.withOpacity(0.2))
        ]),
        child: TextField(
          keyboardType: TextInputType.text,
          focusNode: focusNode,
          onChanged: (value) {
            bloc?.add(SearchFieldClicked(value));
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            hintText: 'جست و جو',
            hintStyle: TextStyle(
                fontFamily: MyApp.fontFamily, color: theme.colorScheme.primary),
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
