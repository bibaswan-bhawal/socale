import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socale/transitions/curves.dart';
import 'package:socale/utils/system_ui.dart';

typedef ClosedCallback<S> = void Function(S data);
typedef CloseContainerActionCallback<S> = void Function({S? returnValue});
typedef ChildContentBuilder<S> = Widget Function(BuildContext context, CloseContainerActionCallback<S> action);
typedef ParentContentBuilder = Widget Function(BuildContext context, VoidCallback action);
typedef BackgroundBuilder = Widget Function(BuildContext context, Widget child, Animation<double> animation);

@optionalTypeArgs
class ContainerTransform<T extends Object?> extends StatefulWidget {
  const ContainerTransform({
    super.key,
    required this.childBuilder,
    required this.parentBuilder,
    this.backgroundBuilder,
    this.onClosed,
    this.routeSettings,
    this.useRootNavigator = false,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  final ClosedCallback<T?>? onClosed;
  final ChildContentBuilder<T?> childBuilder;
  final ParentContentBuilder parentBuilder;
  final BackgroundBuilder? backgroundBuilder;

  final Duration transitionDuration;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;

  @override
  State<ContainerTransform<T?>> createState() => _ContainerTransformState<T>();
}

class _ContainerTransformState<T> extends State<ContainerTransform<T?>> {
  // Key used in [_OpenChildRoute] to hide the widget returned by
  // [ContainerTransform.childBuilder] in the source route while the container is
  // opening/open. A copy of that widget is included in the
  // [_OpenChildRoute] where it fades out. To avoid issues with double
  // shadows and transparency, we hide it in the source route.
  final GlobalKey<_HideableState> _hideableKey = GlobalKey<_HideableState>();

  // Key used to steal the state of the widget returned by
  // [ContainerTransform.childBuilder] from the source route and attach it to the
  // same widget included in the [_OpenChildRoute] where it fades out.
  final GlobalKey _closedBuilderKey = GlobalKey();

  bool isOpen = false;

  Future<void> openChild() async {
    if (mounted) setState(() => isOpen = true);

    NavigatorState navigator = Navigator.of(context, rootNavigator: widget.useRootNavigator);

    final T? data = await navigator.push(
      _OpenChildRoute<T>(
        hideableKey: _hideableKey,
        closedBuilderKey: _closedBuilderKey,
        parentBuilder: widget.parentBuilder,
        childBuilder: widget.childBuilder,
        backgroundBuilder: widget.backgroundBuilder,
        transitionDuration: widget.transitionDuration,
        useRootNavigator: widget.useRootNavigator,
        routeSettings: widget.routeSettings,
      ),
    );

    if (data != null) widget.onClosed?.call(data);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mounted && isOpen) {
          setState(() => isOpen = false);
          Navigator.of(context, rootNavigator: widget.useRootNavigator).pop();
          return false;
        }

        return true;
      },
      child: _Hideable(
        key: _hideableKey,
        child: Builder(
          key: _closedBuilderKey,
          builder: (BuildContext context) {
            if (widget.backgroundBuilder == null) return widget.parentBuilder(context, openChild);

            return widget.backgroundBuilder!(
              context,
              widget.parentBuilder(context, openChild),
              const AlwaysStoppedAnimation(0.0),
            );
          },
        ),
      ),
    );
  }
}

class _Hideable extends StatefulWidget {
  const _Hideable({super.key, required this.child});

  final Widget child;

  @override
  State<_Hideable> createState() => _HideableState();
}

class _HideableState extends State<_Hideable> {
  bool _visible = true;

  Size? _placeholderSize;

  /// When true the child is not visible, but will maintain its size.
  bool get isVisible => _visible;

  /// When non-null the child is replaced by a [SizedBox] of the set size.
  Size? get placeholderSize => _placeholderSize;

  /// Whether the child is currently included in the tree.
  bool get isInTree => _placeholderSize == null;

  set placeholderSize(Size? value) => (_placeholderSize == value) ? null : setState(() => _placeholderSize = value);

  set isVisible(bool value) => (_visible == value) ? null : setState(() => _visible = value);

  @override
  Widget build(BuildContext context) {
    if (_placeholderSize != null) return SizedBox.fromSize(size: _placeholderSize);

    return Visibility(
      visible: _visible,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      child: widget.child,
    );
  }
}

class _OpenChildRoute<T> extends ModalRoute<T> {
  _OpenChildRoute({
    required this.parentBuilder,
    required this.childBuilder,
    required this.hideableKey,
    required this.closedBuilderKey,
    required this.transitionDuration,
    required this.useRootNavigator,
    this.backgroundBuilder,
    required RouteSettings? routeSettings,
  });

  final ParentContentBuilder parentBuilder;
  final ChildContentBuilder<T> childBuilder;
  final BackgroundBuilder? backgroundBuilder;

  final bool useRootNavigator;

  final GlobalKey<_HideableState> hideableKey;
  final GlobalKey closedBuilderKey;

  @override
  bool get maintainState => false;

  @override
  final Duration transitionDuration;

  @override
  Color? get barrierColor => Colors.black87;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  // Key used for the widget returned by [OpenContainer.openBuilder] to keep
  // its state when the shape of the widget tree is changed at the end of the
  // animation to remove all the craft that was necessary to make the animation
  // work.
  final GlobalKey _openBuilderKey = GlobalKey();

  // Defines the position and the size of the (opening) [OpenContainer] within
  // the bounds of the enclosing [Navigator].
  final RectTween _rectTween = RectTween();

  AnimationStatus? _lastAnimationStatus;
  AnimationStatus? _currentAnimationStatus;

  void _transitionStatusListener(AnimationStatus status) {
    _lastAnimationStatus = _currentAnimationStatus;
    _currentAnimationStatus = status;

    switch (status) {
      case AnimationStatus.dismissed:
        _toggleHideable(hide: false);
      case AnimationStatus.completed:
        _toggleHideable(hide: true);
      default:
        break;
    }
  }

  @override
  TickerFuture didPush() {
    _takeMeasurements(navigatorContext: hideableKey.currentContext!);
    animation!.addStatusListener(_transitionStatusListener);
    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    _takeMeasurements(navigatorContext: subtreeContext!, delayForSourceRoute: true);
    return super.didPop(result);
  }

  @override
  void dispose() {
    if (hideableKey.currentState?.isVisible == false) {
      SchedulerBinding.instance.addPostFrameCallback((Duration d) => _toggleHideable(hide: false));
    }
    super.dispose();
  }

  void _toggleHideable({required bool hide}) {
    if (hideableKey.currentState != null) {
      hideableKey.currentState!
        ..placeholderSize = null
        ..isVisible = !hide;
    }
  }

  void _takeMeasurements({required BuildContext navigatorContext, bool delayForSourceRoute = false}) {
    final NavigatorState navigator = Navigator.of(navigatorContext, rootNavigator: useRootNavigator);
    final RenderBox navigatorRenderBox = navigator.context.findRenderObject()! as RenderBox;

    final Size navSize = _getSize(navigatorRenderBox);

    _rectTween.end = Offset.zero & navSize;

    void takeMeasurementsInSourceRoute([Duration? _]) {
      if (!navigatorRenderBox.attached || hideableKey.currentContext == null) {
        return;
      }

      _rectTween.begin = _getRect(hideableKey, navigatorRenderBox);
      hideableKey.currentState!.placeholderSize = _rectTween.begin!.size;
    }

    if (delayForSourceRoute) {
      SchedulerBinding.instance.addPostFrameCallback(takeMeasurementsInSourceRoute);
    } else {
      takeMeasurementsInSourceRoute();
    }
  }

  Size _getSize(RenderBox render) {
    assert(render.hasSize);
    return render.size;
  }

  // Returns the bounds of the [RenderObject] identified by `key` in the
  // coordinate system of `ancestor`.
  Rect _getRect(GlobalKey key, RenderBox ancestor) {
    assert(key.currentContext != null);
    assert(ancestor.hasSize);

    final RenderBox render = key.currentContext!.findRenderObject()! as RenderBox;

    assert(render.hasSize);

    final Rect boundsInAncestor = MatrixUtils.transformRect(
      render.getTransformTo(ancestor),
      Offset.zero & render.size,
    );

    return boundsInAncestor;
  }

  bool get _transitionWasInterrupted {
    bool wasInProgress = false;
    bool isInProgress = false;

    switch (_currentAnimationStatus) {
      case AnimationStatus.completed || AnimationStatus.dismissed:
        isInProgress = false;
      case AnimationStatus.forward || AnimationStatus.reverse:
        isInProgress = true;
      default:
    }

    switch (_lastAnimationStatus) {
      case AnimationStatus.completed || AnimationStatus.dismissed:
        wasInProgress = false;
      case AnimationStatus.forward || AnimationStatus.reverse:
        wasInProgress = true;
      default:
    }

    return wasInProgress && isInProgress;
  }

  void closeContainer({T? returnValue}) => Navigator.of(subtreeContext!).pop(returnValue);

  Widget _buildContent(Animation<double> animation, Rect rect) {
    final Animatable<double> firstVisAnimation = Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: const Interval(0, 0.3)));

    final Animatable<double> secondVisAnimation =
        Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: const Interval(0.3, 1)));

    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (!(hideableKey.currentState?.isInTree ?? false))
          Opacity(
            opacity: firstVisAnimation.evaluate(animation),
            child: Builder(
              key: closedBuilderKey,
              builder: (BuildContext context) => parentBuilder(context, closeContainer),
            ),
          ),
        Opacity(
          opacity: secondVisAnimation.evaluate(animation),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: _rectTween.end!.height,
              width: _rectTween.end!.width,
              child: Builder(
                key: _openBuilderKey,
                builder: (BuildContext context) => childBuilder(context, closeContainer),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoute(Animation<double> animation, BuildContext context, Rect rect) {
    if (backgroundBuilder == null) return _buildContent(animation, rect);

    return Builder(
      builder: (context) => backgroundBuilder!(context, _buildContent(animation, rect), animation),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, _) {
    return Align(
      alignment: Alignment.topLeft,
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          if (animation.isCompleted) {
            return Material(
              type: MaterialType.transparency,
              child: Builder(
                key: _openBuilderKey,
                builder: (BuildContext context) {
                  return childBuilder(context, closeContainer);
                },
              ),
            );
          }

          final Animation<double> curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: emphasized,
            reverseCurve: _transitionWasInterrupted ? null : emphasized.flipped,
          );

          final Rect rect = _rectTween.evaluate(curvedAnimation)!;

          return Transform.translate(
            offset: Offset(rect.left, rect.top),
            child: Material(
              clipBehavior: Clip.antiAlias,
              type: MaterialType.transparency,
              child: SizedBox(
                width: rect.width,
                height: rect.height,
                child: _buildRoute(curvedAnimation, context, rect),
              ),
            ),
          );
        },
      ),
    );
  }
}
