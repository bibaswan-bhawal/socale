import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:socale/components/selectors/container_chip_selector.dart';
import 'package:socale/utils/system_ui.dart';

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({Key? key}) : super(key: key);

  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = 40 - MediaQuery.of(context).padding.bottom;

    return SafeArea(
      child: Column(
        children: [
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(left: 36, right: 36, bottom: bottomPadding),
            child: OpenContainer(
              closedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              closedColor: Colors.transparent,
              closedElevation: 2,
              transitionType: ContainerTransitionType.fadeThrough,
              openBuilder: (context, _) => _DetailsPage(message: 'hello'),
              closedBuilder: (context, openContainer) => ContainerChipSelector(emptyMessage: 'Add a Major'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  final String message;
  const _DetailsPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
