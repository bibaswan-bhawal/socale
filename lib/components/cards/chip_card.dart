import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/animations/fade_through_animation.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/resources/colors.dart';

class ChipCard extends StatelessWidget {
  final String emptyMessage;

  final double height;
  final double horizontalPadding;

  final List<String> options;

  const ChipCard({
    super.key,
    required this.height,
    required this.horizontalPadding,
    required this.emptyMessage,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return _ChipContainerTransform(
      height: height,
      horizontalPadding: horizontalPadding,
      options: options,
    );
  }
}

class _ChipContainerTransform extends StatefulWidget {
  final double height;
  final double horizontalPadding;

  final List<String> options;

  const _ChipContainerTransform(
      {required this.height, required this.horizontalPadding, required this.options});

  @override
  State<_ChipContainerTransform> createState() => _ChipContainerTransformState();
}

class _ChipContainerTransformState extends State<_ChipContainerTransform>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlay;

  late AnimationController controller;
  late Animation<double> animation;

  bool showMain = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 250),
        vsync: this);

    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        Overlay.of(context).setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() => showMain = true);
          overlay?.remove();
          overlay = null;
        } else {
          setState(() => showMain = false);
        }
      });
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  Widget mainWidgetBuilder() {
    return SizedBox(
      height: widget.height,
      child: _ChipContainer(
        onAdd: () => createOverlay(),
        child: const _ChipContentPlaceHolder(
          placeholderText: 'add your major',
        ),
      ),
    );
  }

  Widget secondaryWidgetBuilder() {
    return _SelectionMenu(
      onPressed: () => removeOverlay(),
      options: widget.options,
    );
  }

  Animatable<double> getVOffsetAnimation(verticalOffset) =>
      Tween<double>(begin: verticalOffset, end: 0).chain(CurveTween(curve: emphasized));

  Animatable<double> get paddingAnimation =>
      Tween<double>(begin: widget.horizontalPadding, end: 00).chain(CurveTween(curve: emphasized));

  Animatable<double> get heightAnimation =>
      Tween(begin: widget.height, end: MediaQuery.of(context).size.height)
          .chain(CurveTween(curve: emphasized));

  Animatable<Color?> get colorAnimation =>
      ColorTween(begin: Colors.white.withOpacity(0), end: Colors.white)
          .chain(CurveTween(curve: emphasized));

  void createOverlay() {
    OverlayState overlayState = Overlay.of(context);
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    Offset offset = renderBox!.localToGlobal(Offset.zero);

    controller.forward();

    overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: paddingAnimation.evaluate(animation),
        right: paddingAnimation.evaluate(animation),
        top: getVOffsetAnimation(offset.dy).evaluate(animation),
        child: Container(
          color: colorAnimation.evaluate(animation),
          height: heightAnimation.evaluate(animation),
          child: FadeThroughAnimation(
            animation: animation,
            first: mainWidgetBuilder(),
            second: secondaryWidgetBuilder(),
          ),
        ),
      ),
    );

    overlayState.insert(overlay!);
  }

  void removeOverlay() {
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showMain,
      maintainAnimation: true,
      maintainState: true,
      maintainSize: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: SizedBox(
          height: widget.height,
          child: mainWidgetBuilder(),
        ),
      ),
    );
  }
}

class _ChipContentPlaceHolder extends StatelessWidget {
  final String placeholderText;

  const _ChipContentPlaceHolder({required this.placeholderText});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(placeholderText));
  }
}

class _ChipContainer extends StatelessWidget {
  final Widget child;
  final Function() onAdd;

  const _ChipContainer({required this.child, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(15),
        gradient: ColorValues.groupInputBackgroundGradient,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 8,
              child: InkResponse(
                onTap: onAdd,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset('assets/icons/add.svg', color: Colors.black),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _SelectionMenu extends StatefulWidget {
  final Function() onPressed;
  final List<String> options;

  const _SelectionMenu({required this.onPressed, required this.options});

  @override
  State<_SelectionMenu> createState() => _SelectionMenuState();
}

class _SelectionMenuState extends State<_SelectionMenu> {
  late List<String> options;
  late List<String> filteredOptions;

  String searchText = '';

  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();

    options = List<String>.from(widget.options);
    options.sort();
    filteredOptions = options;
  }

  void buildList() {
    if (searchText.isNotEmpty) {
      List<String> sortedFilteredList = options.where((option) {
        return option.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      sortedFilteredList.sort();

      setState(() => filteredOptions = sortedFilteredList);
    } else {
      options.sort();
      setState(() => filteredOptions = options);
    }
  }

  void onSelected(index) {
    selectedOptions.add(filteredOptions[index]);
    options.removeWhere((element) => selectedOptions.contains(element));
    buildList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10 + MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: InkResponse(
                    radius: 20,
                    splashFactory: InkRipple.splashFactory,
                    onTap: widget.onPressed,
                    child: SvgPicture.asset('assets/icons/back.svg', fit: BoxFit.fill),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (value) {
                        searchText = value;
                        buildList();
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintText: 'Search for Your Major',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 40),
            child: Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
                Chip(label: Text('Bob')),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8),
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  onTap: () => onSelected(index),
                  title: Text(filteredOptions[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          )
        ],
      ),
    );
  }
}
