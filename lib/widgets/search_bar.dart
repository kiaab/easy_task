import 'package:easy_task/main.dart';
import 'package:easy_task/ui/home/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.theme,
    required this.focusNode,
  }) : super(key: key);

  final ThemeData theme;

  final FocusNode focusNode;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Container(
        height: 52,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: 20,
              color: widget.theme.colorScheme.primary.withOpacity(0.2))
        ]),
        child: TextField(
          style: widget.theme.textTheme.bodyText2,
          controller: searchController,
          keyboardType: TextInputType.text,
          focusNode: widget.focusNode,
          onChanged: (value) {
            getIt<HomeBloc>()
                .add(SearchFieldClicked(searchKey: searchController.text));
          },
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              hintText: 'جست و جو',
              hintStyle: TextStyle(
                  fontFamily: MyApp.fontFamily,
                  color: widget.theme.colorScheme.primary),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: widget.theme.colorScheme.primary,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        searchController.text = '';
                        getIt<HomeBloc>().add(SearchFieldClicked(
                            searchKey: searchController.text));
                      },
                      child: Icon(
                        CupertinoIcons.clear,
                        color: widget.theme.colorScheme.primary,
                      ),
                    )
                  : null),
        ),
      ),
    );
  }
}
