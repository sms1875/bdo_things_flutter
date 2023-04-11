import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomNavigationRail extends StatefulWidget {
  const CustomNavigationRail({Key? key}) : super(key: key);

  @override
  _CustomNavigationRailState createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  int _selectedIndex = 0; // 기본값으로 0을 지정해줍니다.

  @override
  void didChangeDependencies() {
    _selectedIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    super.didChangeDependencies();
  }

  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  double groupAligment = -1.0;

  List<NavigationRailDestination> getDestinations() {
    return List<NavigationRailDestination>.generate(
      pageList.length,
          (index) => NavigationRailDestination(
        icon: Icon(pageList[index]['icon']),
        selectedIcon: Icon(
          pageList[index]['icon'],
          color: Colors.red, // 강조할 색상 지정
        ),
        label: Text(pageList[index]['name']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: Constants.backgroundColor,
      selectedIndex: _selectedIndex,
      groupAlignment: groupAligment,
      labelType: labelType,
      destinations: getDestinations(),
      onDestinationSelected: (int index) {
        Navigator.pushNamed(
            context,
            pageList[index]['name'],
            arguments: index
        );
      },
    );
  }
}

List<Map<String, dynamic>> pageList = [
  {
    'name': 'Home',
    'icon': Icons.home,
  },
  {
    'name': 'Tools',
    'icon': Icons.pan_tool,
  },
  {
    'name': 'Test1',
    'icon': Icons.star_border,
  },
  {
    'name': 'Test2',
    'icon': Icons.star_border,
  },
  {
    'name': 'Setting',
    'icon': Icons.settings,
  },
];