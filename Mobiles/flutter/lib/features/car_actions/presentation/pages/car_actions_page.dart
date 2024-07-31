import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/presentation/pages/phone_to_car_actions_page.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/presentation/pages/remote_actions_page.dart';

class CarActionsPage extends StatefulWidget {
  const CarActionsPage({super.key});

  @override
  State<CarActionsPage> createState() => _CarActionsPageState();
}

class _CarActionsPageState extends State<CarActionsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Phone To Car Actions',
                icon: Icon(Icons.phone_android),
              ),
              Tab(
                text: 'Remote Actions',
                icon: Icon(Icons.language),
              ),
            ],
          ),
          title: const Text('Car Actions'),
        ),
        body: const TabBarView(
          children: [
            PhoneToCarActionsPage(),
            RemoteActionsPage(),
          ],
        ),
      ),
    );
  }
}
