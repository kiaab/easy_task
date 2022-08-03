import 'package:easy_task/ui/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchIcon extends StatefulWidget {
  const SearchIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchIcon> createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  bool showSearch(BuildContext context) {
    if (homeScrollController.hasClients) {
      final scrollPosition = homeScrollController.offset;
      if (scrollPosition > (MediaQuery.of(context).size.height * 0.2)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    homeScrollController.addListener(
      () {
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    homeScrollController.removeListener(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 80),
      scale: showSearch(context) ? 2 : 0,
      child: Visibility(
        visible: showSearch(context),
        child: const Icon(
          CupertinoIcons.search,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }
}
