import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/widgets/phone_to_car/phone_to_car_actions_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/widgets/remote_actions_widget.dart';

class CarActionsPage extends StatefulWidget {
  const CarActionsPage({super.key});

  @override
  State<CarActionsPage> createState() => _CarActionsPageState();
}

class _CarActionsPageState extends State<CarActionsPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PhoneToCarActionsWidget(),
    RemoteActionsWidget(),
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
