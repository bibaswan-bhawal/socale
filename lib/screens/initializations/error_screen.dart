import 'package:flutter/material.dart';
import 'package:socale/components/backgrounds/light_background.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          LightBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [Text('Error')],
          )
        ],
      ),
    );
  }
}
