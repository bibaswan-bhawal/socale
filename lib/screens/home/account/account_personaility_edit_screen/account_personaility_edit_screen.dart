import 'package:flutter/material.dart';

class AccountPersonailityEditScreen extends StatelessWidget {
  const AccountPersonailityEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Row(children: [
              GestureDetector(
                child: Icon(Icons.arrow_back_ios_new),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
