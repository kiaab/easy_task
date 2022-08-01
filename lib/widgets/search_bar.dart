import 'package:easy_task/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Container(
        height: 52,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: 20, color: theme.colorScheme.primary.withOpacity(0.2))
        ]),
        child: TextField(
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
