import 'package:easy_task/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? checked = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          CupertinoIcons.plus,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
                elevation: 0,
                floating: true,
                pinned: true,
                snap: false,
                title: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سلام کیا',
                        style: theme.textTheme.headline6!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          'امروز 5 تسک برای انجام دادن داری',
                          style: theme.textTheme.bodyText2!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
                expandedHeight: MediaQuery.of(context).size.width * 0.3,
                bottom: PreferredSize(
                  child: SearchBar(theme: theme),
                  preferredSize: const Size.fromHeight(56),
                )),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(36))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: RichText(
                          text: TextSpan(
                              style: theme.textTheme.headline4,
                              text: 'پروژه ها',
                              children: [
                            TextSpan(
                                text: '(2)',
                                style: theme.textTheme.headline4!
                                    .copyWith(color: MyApp.primaryTextColor))
                          ])),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                              left: 32, right: 32, bottom: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (contex, index) {
                            return Stack(
                              children: [
                                Positioned.fill(
                                  bottom: 6,
                                  top: 60,
                                  left: 28,
                                  right: 28,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.3),
                                            blurRadius: 10)
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                  width: 200,
                                  height: 140,
                                  margin: EdgeInsets.fromLTRB(
                                      index == 1 ? 0 : 8,
                                      12,
                                      index == 0 ? 0 : 8,
                                      12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'پروژه اندروید',
                                        style: theme.textTheme.headline4!
                                            .copyWith(
                                                fontSize: 14,
                                                color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'تسک های انجام شده :',
                                        style: theme.textTheme.caption,
                                      ),
                                      Text(
                                        'تسک های باقی مانده :',
                                        style: theme.textTheme.caption,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      LinearPercentIndicator(
                                        barRadius: Radius.circular(12),
                                        padding: EdgeInsets.zero,
                                        percent: 0.5,
                                        progressColor:
                                            theme.colorScheme.secondary,
                                        backgroundColor: Colors.white,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'پیشرفت',
                                            style: theme.textTheme.caption,
                                          ),
                                          Text(
                                            '20%',
                                            style: theme.textTheme.caption,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 32, top: 8),
                      child: Text(
                        'تسک ها',
                        style: theme.textTheme.headline4,
                      ),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.only(bottom: 55),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemExtent: 85,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            margin: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: checked!
                                    ? theme.colorScheme.secondary
                                        .withOpacity(0.2)
                                    : null,
                                border: Border.all(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.2))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'انجام تکالیف',
                                  style: TextStyle(
                                      decoration: checked!
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                Checkbox(
                                    activeColor: theme.colorScheme.secondary,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: theme.colorScheme.secondary),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    value: checked,
                                    onChanged: (value) {
                                      setState(() {
                                        checked = value;
                                      });
                                    })
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      child: SizedBox(
        height: 52,
        child: TextField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            hintText: 'جست و جو',
            hintStyle: TextStyle(
                fontFamily: MyApp.fontFamily, color: MyApp.primaryTextColor),
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: MyApp.primaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
