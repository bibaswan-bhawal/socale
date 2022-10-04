import 'dart:io';

import 'package:socale/utils/constraints/constraints_ios.dart';
import 'package:socale/utils/constraints/constraints_android.dart';

class AppConstraint {
  late double onboardingSituational1ImagePadding;
  late double onboardingSituational2ImagePadding;
  late double onboardingSituational3ImagePadding;
  late double onboardingSituational4ImagePadding;
  late double onboardingSituational5ImagePadding;

  late double getStartedTopPadding;

  late double chatPageAppBarHeight;
  late double settingsPageAppBarHeight;

  AppConstraint() {
    if (Platform.isAndroid) {
      onboardingSituational1ImagePadding = constraintsAndroid.onboardingSituational1ImagePadding;
      onboardingSituational2ImagePadding = constraintsAndroid.onboardingSituational2ImagePadding;
      onboardingSituational3ImagePadding = constraintsAndroid.onboardingSituational3ImagePadding;
      onboardingSituational4ImagePadding = constraintsAndroid.onboardingSituational4ImagePadding;
      onboardingSituational5ImagePadding = constraintsAndroid.onboardingSituational5ImagePadding;

      getStartedTopPadding = constraintsAndroid.getStartedTopPadding;

      chatPageAppBarHeight = constraintsAndroid.chatPageAppBarHeight;
      settingsPageAppBarHeight = constraintsAndroid.settingsPageAppBarHeight;
    } else if (Platform.isIOS) {
      onboardingSituational1ImagePadding = constraintsIOS.onboardingSituational1ImagePadding;
      onboardingSituational2ImagePadding = constraintsIOS.onboardingSituational2ImagePadding;
      onboardingSituational3ImagePadding = constraintsIOS.onboardingSituational3ImagePadding;
      onboardingSituational4ImagePadding = constraintsIOS.onboardingSituational4ImagePadding;
      onboardingSituational5ImagePadding = constraintsIOS.onboardingSituational5ImagePadding;

      getStartedTopPadding = constraintsIOS.getStartedTopPadding;

      chatPageAppBarHeight = constraintsIOS.chatPageAppBarHeight;
      settingsPageAppBarHeight = constraintsIOS.settingsPageAppBarHeight;
    }
  }
}

final constraints = AppConstraint();
