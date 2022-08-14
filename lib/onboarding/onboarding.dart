import 'package:easy_task/main.dart';
import 'package:easy_task/ui/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TextEditingController controller = TextEditingController();

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> searchAnimation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    searchAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeData.colorScheme.primary,
        onPressed: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Directionality(
                  textDirection: TextDirection.rtl, child: HomeScreen())));
          saveName();
          name = await getName();
        },
        child: const Icon(
          CupertinoIcons.arrow_right,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 28),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Opacity(
                  opacity: _animationController.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/logo2.svg',
                        width: 135,
                        height: 135,
                        color: themeData.colorScheme.primary,
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Text(
                        'به Easy Task خوش اومدی اسم خودتو وارد کن و تسک های روزانه و پروژه هاتو مدیریت کن',
                        style: themeData.textTheme.headline6!.copyWith(
                          color: MyApp.primaryTextColor,
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          label: Text(
                            'نام',
                            style: themeData.textTheme.bodyText2,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: MyApp.primaryTextColor),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: MyApp.primaryTextColor),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void saveName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('name', controller.text);
  newUser = false;
  preferences.setBool('newUser', newUser);
}

Future<String> getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('name') ?? '';
}

Future<bool> isNewUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('newUser') ?? true;
}
