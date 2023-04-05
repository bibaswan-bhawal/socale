import 'package:flutter/material.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/utils/system_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemUI.setSystemUILight();

    return ScreenScaffold(
      background: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
