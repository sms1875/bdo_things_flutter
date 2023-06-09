import 'package:bdo_things/screen/base/base_page.dart';
import 'package:flutter/material.dart';
import 'widgets/tools_widget.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({Key? key}) : super(key: key);

  static const pageTitle = 'Tools';

  @override
  Widget build(BuildContext context) {
    return BasePage(
      pageTitle: ToolsPage.pageTitle,
      body: ToolsWidget(),
    );
  }
}