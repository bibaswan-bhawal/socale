import 'package:flutter/material.dart';
import 'package:socale/components/utils/page_view/animated_page_view.dart';

class PageViewHero extends StatefulWidget {
  final Object tag;
  final Widget child;
  final BuildContext parentContext;

  const PageViewHero({
    super.key,
    required this.tag,
    required this.child,
    required this.parentContext,
  });

  /* Get all heroes in the current context */

  static Map<Object, PageViewHeroState> allHeroesFor(BuildContext context) {
    final result = <Object, PageViewHeroState>{};

    void visitor(Element element) {
      if (element.widget is PageViewHero) {
        final heroElement = element as StatefulElement;
        final heroWidget = element.widget as PageViewHero;

        final Object tag = heroWidget.tag;

        final PageViewHeroState heroState = heroElement.state as PageViewHeroState;

        result[tag] = heroState;
      }
      // Don't perform transitions across different Animated Page Views.
      if (element.widget is AnimatedPageView) return;

      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);

    return result;
  }

  @override
  PageViewHeroState createState() => PageViewHeroState();
}

class PageViewHeroState extends State<PageViewHero> {
  bool isVisible = true;

  OverlayEntry? overlay;

  Offset? savedOffset;
  RenderBox? renderBox;

  void hide() {
    if (mounted) setState(() => isVisible = false);
    createOverlay();
  }

  void saveOffset() {
    renderBox ??= context.findRenderObject() as RenderBox?;
    savedOffset ??= renderBox!.localToGlobal(Offset.zero);
  }

  void show() {
    if (mounted) setState(() => isVisible = true);

    renderBox = null;
    savedOffset = null;

    overlay?.remove();
    overlay = null;
  }

  void createOverlay() {
    if (overlay != null) return;

    OverlayState overlayState = Overlay.of(context);

    overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: savedOffset!.dx,
        top: savedOffset!.dy,
        child: IgnorePointer(
          child: Material(
            type: MaterialType.transparency,
            child: SizedBox(
              width: renderBox!.size.width,
              height: renderBox!.size.height,
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlay!);
  }

  @override
  void dispose() {
    overlay?.remove();
    overlay = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: widget.child,
    );
  }
}
