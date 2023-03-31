import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/animations/fade_through_animation.dart';
import 'package:socale/components/buttons/icon_button.dart';
import 'package:socale/models/data_model.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/transitions/curves.dart';

class ChipCard<T> extends StatefulWidget {
  final double horizontalPadding;
  final String placeholder;
  final String searchHint;
  final List<T>? options;
  final List<T> initialOptions;
  final bool hasError;
  final String? errorText;

  final Function onChanged;

  const ChipCard({
    super.key,
    required this.horizontalPadding,
    required this.options,
    required this.initialOptions,
    required this.placeholder,
    required this.searchHint,
    required this.onChanged,
    required this.hasError,
    this.errorText,
  });

  @override
  State<ChipCard> createState() => _ChipCardState<T>();
}

class _ChipCardState<T> extends State<ChipCard> with SingleTickerProviderStateMixin {
  GlobalKey<_SelectionMenuState> menuKey = GlobalKey<_SelectionMenuState>();

  late double widgetHeight;
  late AnimationController controller;
  late Animation<double> animation;
  late List<T> selectedOptions;

  OverlayEntry? overlay;

  bool showMain = true;

  @override
  void initState() {
    super.initState();

    initializeAnimationController();
    selectedOptions = (widget.initialOptions as List<T>).toList();
  }

  setOptions(options) {
    widget.onChanged(options);
    setState(() => selectedOptions = options);
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

    for (T option in selectedOptions) {
      chips.add(
        Chip(
          key: ValueKey(option.hashCode),
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(4),
          label: Text(option.toString(), style: GoogleFonts.roboto(fontSize: 12)),
          onDeleted: () => setState(() {
            selectedOptions.removeAt(selectedOptions.indexOf(option));
            widget.onChanged(selectedOptions);
          }),
        ),
      );
    }

    return chips;
  }

  Widget mainWidgetBuilder({double? height}) {
    return SizedBox(
      height: height,
      child: GestureDetector(
        onTap: () => createOverlay(),
        child: _ChipContainer(
          hasError: widget.hasError,
          errorText: widget.errorText,
          horizontalPadding: widget.horizontalPadding,
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
    return _SelectionMenu<T>(
      onPressed: () => removeOverlay(),
      searchHint: widget.searchHint,
      options: widget.options as List<T>?,
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

  void createOverlay() {
    OverlayState overlayState = Overlay.of(context, rootOverlay: true);
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    Offset offset = renderBox!.localToGlobal(Offset.zero);

    overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: paddingAnimation.evaluate(animation),
        right: paddingAnimation.evaluate(animation),
        top: getVOffsetAnimation(offset.dy).evaluate(animation),
        child: FadeThroughAnimation(
          animation: animation,
          background: Container(
            color: Colors.white,
            height: heightAnimation.evaluate(animation),
            width: double.infinity,
          ),
          first: mainWidgetBuilder(height: heightAnimation.evaluate(animation)),
          second: secondaryWidgetBuilder(),
        ),
      ),
    );

    overlayState.insert(overlay!);
    controller.forward();
  }

  Future<void> removeOverlay() async => await controller.reverse();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxHeight == double.infinity) return mainWidgetBuilder();
                    return mainWidgetBuilder(height: constraints.maxHeight);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: widget.hasError ? 1 : 0,
                  child: Text(
                    widget.errorText ?? '',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
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

  final bool hasError;
  final String? errorText;

  final double horizontalPadding;

  const _ChipContainer({
    required this.child,
    required this.onAdd,
    required this.hasError,
    required this.horizontalPadding,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: hasError ? Colors.red : Colors.black, width: hasError ? 3 : 2),
        borderRadius: BorderRadius.circular(15),
        gradient: ColorValues.groupInputBackgroundGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }
}

class _SelectionMenu<T> extends StatefulWidget {
  final Function() onPressed;
  final List<T> selectedOptions;

  final String searchHint;
  final List<T>? options;

  final dynamic Function(List<T>) onChanged;

  const _SelectionMenu({
    required this.onPressed,
    required this.options,
    required this.searchHint,
    required this.onChanged,
    required this.selectedOptions,
  });

  @override
  State<_SelectionMenu> createState() => _SelectionMenuState<T>();
}

class _SelectionMenuState<T> extends State<_SelectionMenu> {
  late List<T> options;
  late List<T> filteredOptions;
  late List<T> selectedOptions;

  String searchText = '';

  @override
  void initState() {
    super.initState();

    selectedOptions = (widget.selectedOptions as List<T>).toList();

    options = (widget.options as List<T>?) ?? [];
    options.sort((a, b) => (a as Comparable).compareTo(b));
    filteredOptions = options;

    filteredOptions.removeWhere((element) => selectedOptions.contains(element));
  }

  void buildList() {
    if (searchText.isNotEmpty) {
      List<T> sortedFilteredList =
          options.where((option) => option.toString().toLowerCase().contains(searchText.toLowerCase())).toList();

      sortedFilteredList.sort((a, b) => ((a as Comparable)).compareTo(b));

      setState(() => filteredOptions = sortedFilteredList);
    } else {
      options.sort((a, b) => (a as Comparable).compareTo(b));
      setState(() => filteredOptions = options);
    }
  }

  void onSelected(index) {
    T selectedOption = filteredOptions[index];
    options.remove(selectedOption); // remove from list
    buildList(); // rebuild list
    setState(() => selectedOptions.add(selectedOption)); // update state
    widget.onChanged(selectedOptions);
  }

  void onDeleted(index) {
    T selectedOption = selectedOptions[index];
    if (mounted) setState(() => selectedOptions.remove(selectedOption));
    options.add(selectedOption);
    buildList();
    widget.onChanged(selectedOptions);
  }

  onBack() => widget.onPressed();

  onSave() => widget.onPressed();

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
                      children: selectedOptions.map((value) {
                        T option = (value as DataModel).copyWith();

                        return Chip(
                          key: ValueKey(option),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.all(4),
                          label: Text(option.toString(), style: GoogleFonts.roboto(fontSize: 12)),
                          onDeleted: () => onDeleted(selectedOptions.indexOf(option)),
                          clipBehavior: Clip.antiAlias,
                        );
                      }).toList(),
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
                              child: Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(top: 8),
                                  itemCount: filteredOptions.length,
                                  separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
                                  findChildIndexCallback: (Key key) {
                                    int index = filteredOptions.indexOf((key as ValueKey).value);
                                    return index == -1 ? null : index;
                                  },
                                  itemBuilder: (context, index) {
                                    T option = (filteredOptions[index] as DataModel).copyWith();

                                    return ListTile(
                                      key: ValueKey(option),
                                      dense: true,
                                      onTap: () => onSelected(index),
                                      title: Text(option.toString()),
                                    );
                                  },
                                ),
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
