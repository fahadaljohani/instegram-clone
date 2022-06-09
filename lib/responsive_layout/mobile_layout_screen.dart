import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/utils/global_varibales.dart';
import 'package:instegram_clone/Model/user.dart';

class MobileScreenLayouts extends StatefulWidget {
  const MobileScreenLayouts({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayouts> createState() => _MobileScreenLayoutsState();
}

class _MobileScreenLayoutsState extends State<MobileScreenLayouts> {
  int _page = 0;
  late PageController pageController;
  User? user;
  void navigateTo(int page) {
    pageController.jumpToPage(page);
  }

  void pageChanged(page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: pageChanged,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        currentIndex: _page,
        activeColor: primaryColor,
        inactiveColor: secondaryColor,
        onTap: navigateTo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
    );
  }
}
