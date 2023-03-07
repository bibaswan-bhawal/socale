import 'package:flutter/material.dart';
import 'package:socale/components/utils/screen_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
