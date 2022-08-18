import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/routes/custom_transition.dart';

class SharedXAxisTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child);
  }
}
