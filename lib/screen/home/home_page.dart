import 'package:bdo_things/screen/base/base_page.dart';
import 'package:bdo_things/screen/home/widgets/home_widget.dart';
import 'package:flutter/material.dart';

import '../tools/widgets/tools_widget.dart';



class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const pageTitle = 'Home';

  @override
  Widget build(BuildContext context) {
    return BasePage(
      pageTitle: HomePage.pageTitle,
      body: ToolsWidget()//HomeWidget(),
    );
  }
}