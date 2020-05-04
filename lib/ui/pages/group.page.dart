import 'package:daruma/ui/widget/bottom-navigation-bar.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group',
      theme: ThemeData(primaryColor: redPrimaryColor, fontFamily: 'roboto'),
      home: ChangeNotifierProvider<BottomNavigationBarProvider>(
        child: BottomNavigationBarWidget(),
        create: (BuildContext context) => BottomNavigationBarProvider(),
      ),
    );
  }
}
