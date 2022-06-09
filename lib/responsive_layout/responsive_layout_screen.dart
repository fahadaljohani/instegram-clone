import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/providers/user_provider.dart';
import 'package:instegram_clone/utils/global_varibales.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout(
      {Key? key, required this.mobileLayout, required this.webLayout})
      : super(key: key);

  final Widget mobileLayout;
  final Widget webLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > mobileWidth) {
        return widget.webLayout;
      }
      return widget.mobileLayout;
    });
  }
}
