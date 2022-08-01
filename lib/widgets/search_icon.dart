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
    final scrollPosition = homeScreenController.offset;
    if (scrollPosition > (MediaQuery.of(context).size.height * 0.2)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    homeScreenController.addListener(
      () {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    homeScreenController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: Duration(milliseconds: 80),
      scale: showSearch(context) ? 2 : 0,
      child: Visibility(
        visible: showSearch(context),
        child: GestureDetector(
          onTap: () {},
          child: const Icon(
            CupertinoIcons.search,
            color: Colors.white,
            size: 12,
          ),
        ),
      ),
    );
  }
}
