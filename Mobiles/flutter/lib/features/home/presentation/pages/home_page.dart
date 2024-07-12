import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/pages/phone_to_car_actions_page.dart';
import 'package:flutter_mobile_o11y_demo/features/remote_actions/presentation/pages/remote_actions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PhoneToCarActionsPage(),
    RemoteActionsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileO11y Demo'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Phone To Car Actions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: 'Remote Actions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
