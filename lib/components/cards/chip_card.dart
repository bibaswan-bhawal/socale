import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/animations/fade_through_animation.dart';
import 'package:socale/components/buttons/icon_button.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/transitions/curves.dart';

class ChipCard extends StatefulWidget {
  final double horizontalPadding;
  final String placeholder;
  final String searchHint;
  final List? options;
  final List initialOptions;

  final Function(List) onChanged;

  const ChipCard({
    super.key,
    required this.horizontalPadding,
    required this.options,
    required this.initialOptions,
    required this.placeholder,
    required this.searchHint,
    required this.onChanged,
  });

  @override
  State<ChipCard> createState() => _ChipCardState();
}

class _ChipCardState extends State<ChipCard> with SingleTickerProviderStateMixin {
  GlobalKey<_SelectionMenuState> menuKey = GlobalKey<_SelectionMenuState>();

  late double widgetHeight;

  OverlayEntry? overlay;

  late AnimationController controller;
  late Animation<double> animation;

  List selectedOptions = [];

  setOptions(List options) {
    setState(() => selectedOptions = options);
    widget.onChanged(selectedOptions);
  }

  bool showMain = true;

  @override
  void initState() {
    super.initState();

    initializeAnimationController();
    selectedOptions = widget.initialOptions;
  }

  void initializeAnimationController() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(animationListener)
      ..addStatusListener(animationStatusListener);
  }

  animationListener() {
    Overlay.of(context, rootOverlay: true).setState(() {});
  }

  animationStatusListener(status) {
    if (status == AnimationStatus.dismissed) {
      if (mounted) setState(() => showMain = true);
      overlay?.remove();
      overlay = null;
    } else {
      if (mounted) setState(() => showMain = false);
    }
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  List<Widget> chipListBuilder() {
    List<Widget> chips = [];

    for (dynamic option in selectedOptions) {
      chips.add(
        Chip(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(4),
          label: Text(
            option.toString(),
            style: GoogleFonts.roboto(
              fontSize: 12,
            ),
          ),
          onDeleted: () {
            selectedOptions.removeAt(
              selectedOptions.indexOf(option),
            );

            setState(() {});
            widget.onChanged(selectedOptions);
          },
        ),
      );
    }

    return chips;
  }

  Widget mainWidgetBuilder({double? height}) {
    return SizedBox(
      height: height,
      child: GestureDetector(
        onTap: () => selectedOptions.isEmpty ? createOverlay() : null,
        child: _ChipContainer(
          onAdd: () => createOverlay(),
          child: selectedOptions.isEmpty
              ? _ChipContentPlaceHolder(placeholderText: widget.placeholder)
              : Padding(
                  padding: const EdgeInsets.only(left: 16, right: 40),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 8,
                      children: chipListBuilder(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget secondaryWidgetBuilder() {
    return _SelectionMenu(
      onPressed: () => removeOverlay(),
      searchHint: widget.searchHint,
      options: widget.options,
      selectedOptions: selectedOptions,
      onChanged: setOptions,
    );
  }

  Animatable<double> getVOffsetAnimation(verticalOffset) =>
      Tween<double>(begin: verticalOffset, end: 0).chain(CurveTween(curve: emphasized));

  Animatable<double> get paddingAnimation =>
      Tween<double>(begin: widget.horizontalPadding, end: 0).chain(CurveTween(curve: emphasized));

  Animatable<double> get heightAnimation {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    return Tween(begin: renderBox!.size.height, end: MediaQuery.of(context).size.height).chain(
      CurveTween(curve: emphasized),
    );
  }

  Animatable<double> get borderRadius => Tween(begin: 15.0, end: 2.0).chain(CurveTween(curve: emphasized));

  Animatable<Color?> get borderColor =>
      ColorTween(begin: Colors.black, end: Colors.transparent).chain(CurveTween(curve: emphasized));

  void createOverlay() {
    OverlayState overlayState = Overlay.of(context, rootOverlay: true);
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    Offset offset = renderBox!.localToGlobal(Offset.zero);

    overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: paddingAnimation.evaluate(animation),
        right: paddingAnimation.evaluate(animation),
        top: getVOffsetAnimation(offset.dy).evaluate(animation),
        child: Container(
          color: Colors.white,
          child: FadeThroughAnimation(
            animation: animation,
            midPoint: 0.3,
            first: mainWidgetBuilder(height: heightAnimation.evaluate(animation)),
            second: secondaryWidgetBuilder(),
          ),
        ),
      ),
    );

    overlayState.insert(overlay!);
    controller.forward();
  }

  Future<void> removeOverlay() async {
    await controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (overlay == null) return true;
        await removeOverlay();
        return false;
      },
      child: Visibility(
        visible: showMain,
        maintainAnimation: true,
        maintainState: true,
        maintainSize: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxHeight == double.infinity) return mainWidgetBuilder();
              return mainWidgetBuilder(height: constraints.maxHeight);
            },
          ),
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
    return Center(
      child: Text(placeholderText),
    );
  }
}

class _ChipContainer extends StatelessWidget {
  final Widget child;
  final Function() onAdd;

  const _ChipContainer({required this.child, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
            Align(
              alignment: Alignment.topRight,
              child: InkResponse(
                onTap: onAdd,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(
                    'assets/icons/add.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
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
  final List selectedOptions;

  final String searchHint;
  final List? options;

  final Function(List) onChanged;

  const _SelectionMenu({
    required this.onPressed,
    required this.options,
    required this.searchHint,
    required this.onChanged,
    required this.selectedOptions,
  });

  @override
  State<_SelectionMenu> createState() => _SelectionMenuState();
}

class _SelectionMenuState extends State<_SelectionMenu> {
  late List? options;
  late List filteredOptions;

  String searchText = '';

  List selectedOptions = [];

  @override
  void initState() {
    super.initState();

    selectedOptions = widget.selectedOptions;

    if (widget.options == null || widget.options!.isEmpty) return; // no list provided hence loading state.

    options = List.from(widget.options!);
    options!.sort((a, b) => a.compareTo(b));
    filteredOptions = options!;

    filteredOptions.removeWhere((element) => selectedOptions.contains(element));
  }

  void buildList() {
    if (searchText.isNotEmpty) {
      List sortedFilteredList = options!.where((option) {
        return option.toString().toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      sortedFilteredList.sort((a, b) => a.compareTo(b));

      setState(() => filteredOptions = sortedFilteredList);
    } else {
      options!.sort((a, b) => a.compareTo(b));
      setState(() => filteredOptions = options!);
    }
  }

  void onSelected(index) {
    selectedOptions.add(filteredOptions[index]);
    options!.removeWhere((element) => selectedOptions.contains(element));
    buildList();
  }

  List<Widget> _buildChipList() {
    List<Widget> chips = [];

    for (int i = 0; i < selectedOptions.length; i++) {
      chips.add(
        Chip(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(4),
          label: Text(
            selectedOptions[i].toString(),
            style: GoogleFonts.roboto(
              fontSize: 12,
            ),
          ),
          onDeleted: () {
            options!.add(selectedOptions[i]);
            selectedOptions.removeAt(i);
            buildList();
          },
        ),
      );
    }

    return chips;
  }

  onBack() {
    widget.onChanged(selectedOptions);
    widget.onPressed();
  }

  onSave() {
    widget.onChanged(selectedOptions);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return BlockSemantics(
      child: Material(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 10 + MediaQuery.of(context).padding.top,
                  right: 20,
                ),
                child: Row(
                  children: [
                    RippleIconButton(
                      icon: SvgPicture.asset('assets/icons/back.svg', fit: BoxFit.contain),
                      onPressed: onBack,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          onChanged: (value) {
                            searchText = value;
                            buildList();
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(0),
                            hintText: widget.searchHint,
                          ),
                        ),
                      ),
                    ),
                    RippleIconButton(
                      icon: SvgPicture.asset('assets/icons/check.svg', fit: BoxFit.contain),
                      onPressed: onSave,
                      size: const Size(28, 28),
                    ),
                  ],
                ),
              ),
              if (selectedOptions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(maxHeight: 130),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 8,
                      runSpacing: 4,
                      children: _buildChipList(),
                    ),
                  ),
                ),
              Expanded(
                child: widget.options == null
                    ? const Center(child: CircularProgressIndicator())
                    : widget.options!.isEmpty
                        ? Center(
                            child: Text(
                              'There was a problem loading all the options',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ClipRect(
                            child: OverflowBox(
                              maxWidth: MediaQuery.of(context).size.width,
                              minWidth: MediaQuery.of(context).size.width,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(top: 8),
                                itemCount: filteredOptions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    dense: true,
                                    onTap: () => onSelected(index),
                                    title: Text(filteredOptions[index].toString()),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return const Divider(thickness: 0.4, height: 8);
                                },
                              ),
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
