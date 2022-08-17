import 'package:flutter/material.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({Key? key}) : super(key: key);

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Insights Page",
        style: TextStyle(
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
