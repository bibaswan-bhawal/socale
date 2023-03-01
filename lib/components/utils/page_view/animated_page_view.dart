import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:socale/components/utils/page_view/page_view_hero.dart';

class AnimatedPageView extends StatefulWidget {
  final PageController? controller;
  final List<Widget> children;

  final ScrollPhysics? physics;
  final bool allowImplicitScrolling;
  final String? restorationId;
  final Axis scrollDirection;
  final bool reverse;
  final ValueChanged<int>? onPageChanged;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;

  const AnimatedPageView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.onPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  State<AnimatedPageView> createState() => _AnimatedPageViewState();
}

class _AnimatedPageViewState extends State<AnimatedPageView> {
  final List<_Page> pages = [];

  int sourcePage = 0;
  int? targetPage;

  @override
  void initState() {
    super.initState();

    buildPageList();

    sourcePage = widget.controller?.initialPage ?? 0;

    widget.controller?.addListener(_handlePageChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handlePageChanged);
    super.dispose();
  }

  void _handlePageChanged() {
    _calculateSourceAndTargetPage();

    BuildContext sourceContext = pages[sourcePage].subtreeContext!;

    Map<Object, PageViewHeroState> sourceHeroes = PageViewHero.allHeroesFor(sourceContext);

    List<PageViewHeroState> marked = [];

    for (PageViewHeroState source in sourceHeroes.values) {
      source.saveOffset();

      if (targetPage == null) {
        source.show();
        continue;
      }

      source.hide();

      BuildContext? targetContext = pages[targetPage!].subtreeContext;

      if (targetContext == null) {
        source.show();

        continue;
      }

      Map<Object, PageViewHeroState> targetHeroes = PageViewHero.allHeroesFor(targetContext);

      bool found_tag = false;

      for (PageViewHeroState target in targetHeroes.values) {
        target.saveOffset();

        if (target.widget.tag == source.widget.tag) {
          target.hide();

          found_tag = true;
          break;
        }
      }

      if (!found_tag) {
        source.show();
      }
    }
  }

  void _calculateSourceAndTargetPage() {
    final offset = widget.controller!.page!.clamp(0.0, widget.children.length - 1);

    if (offset >= (sourcePage + 1)) {
      sourcePage = sourcePage + (offset - sourcePage).floor();
    } else if (offset <= (sourcePage - 1)) {
      sourcePage = sourcePage - (sourcePage - offset).floor();
    }

    if (offset > sourcePage && offset < (sourcePage + 1)) {
      targetPage = sourcePage + 1;
    } else if (offset < sourcePage && offset > (sourcePage - 1)) {
      targetPage = sourcePage - 1;
    } else {
      targetPage = null;
    }
  }

  buildPageList() {
    for (Widget page in widget.children) {
      pages.add(_Page(child: page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      physics: widget.physics,
      allowImplicitScrolling: widget.allowImplicitScrolling,
      restorationId: widget.restorationId,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      onPageChanged: widget.onPageChanged,
      dragStartBehavior: widget.dragStartBehavior,
      clipBehavior: widget.clipBehavior,
      children: pages.map((beach) => beach.build(context)).toList(),
    );
  }
}

class _Page {
  final Widget child;

  _Page({required this.child});

  final GlobalKey _subtreeKey = GlobalKey();

  BuildContext? get subtreeContext => _subtreeKey.currentContext;

  Widget build(BuildContext context) =>
      RepaintBoundary(key: _subtreeKey, child: Builder(builder: (context) => child));
}
