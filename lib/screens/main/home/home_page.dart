import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/User.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/utils/providers/state_notifier_user.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);
    return Center(
      child: Text(
        "This page is still under development.",
        style: TextStyle(
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
