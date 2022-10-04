import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SettingsSwitch extends StatefulWidget {
  const SettingsSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.trackColor,
    this.thumbColor,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? trackColor;
  final Color? thumbColor;
  final DragStartBehavior dragStartBehavior;

  @override
  State<SettingsSwitch> createState() => _SettingsSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value', value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>('onChanged', onChanged, ifNull: 'disabled'));
  }
}

class _SettingsSwitchState extends State<SettingsSwitch> with TickerProviderStateMixin {
  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;

  late AnimationController _positionController;
  late CurvedAnimation position;

  late AnimationController _reactionController;
  late Animation<double> _reaction;

  bool get isInteractive => widget.onChanged != null;
  bool needsPositionAnimation = false;

  @override
  void initState() {
    super.initState();

    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTap = _handleTap
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..dragStartBehavior = widget.dragStartBehavior;

    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: widget.value ? 1.0 : 0.0,
      vsync: this,
    );
    position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.linear,
    );
    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: this,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.ease,
    );
  }

  @override
  void didUpdateWidget(SettingsSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _drag.dragStartBehavior = widget.dragStartBehavior;

    if (needsPositionAnimation || oldWidget.value != widget.value) {
      _resumePositionAnimation(isLinear: needsPositionAnimation);
    }
  }

  void _resumePositionAnimation({bool isLinear = true}) {
    needsPositionAnimation = false;
    position
      ..curve = isLinear ? Curves.linear : Curves.ease
      ..reverseCurve = isLinear ? Curves.linear : Curves.ease.flipped;
    if (widget.value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) needsPositionAnimation = false;
    _reactionController.forward();
  }

  void _handleTap() {
    if (isInteractive) {
      widget.onChanged!(!widget.value);
      _emitVibration();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.reverse();
    }
  }

  void _handleTapCancel() {
    if (isInteractive) _reactionController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      needsPositionAnimation = false;
      _reactionController.forward();
      _emitVibration();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = Curves.linear;
      final double delta = details.primaryDelta! / _kTrackInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _positionController.value -= delta;
          break;
        case TextDirection.ltr:
          _positionController.value += delta;
          break;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    // Deferring the animation to the next build phase.
    setState(() {
      needsPositionAnimation = true;
    });
    // Call onChanged when the user's intent to change value is clear.
    if (position.value >= 0.5 != widget.value) widget.onChanged!(!widget.value);
    _reactionController.reverse();
  }

  void _emitVibration() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        HapticFeedback.lightImpact();
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (needsPositionAnimation) _resumePositionAnimation();
    return MouseRegion(
      cursor: isInteractive && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      child: Opacity(
        opacity: widget.onChanged == null ? _kCupertinoSwitchDisabledOpacity : 1.0,
        child: _SettingsSwitchRenderObjectWidget(
          value: widget.value,
          activeColor: CupertinoDynamicColor.resolve(
            widget.activeColor ?? CupertinoColors.systemGreen,
            context,
          ),
          trackColor: CupertinoDynamicColor.resolve(widget.trackColor ?? CupertinoColors.secondarySystemFill, context),
          thumbColor: CupertinoDynamicColor.resolve(widget.thumbColor ?? CupertinoColors.white, context),
          onChanged: widget.onChanged,
          textDirection: Directionality.of(context),
          state: this,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tap.dispose();
    _drag.dispose();

    _positionController.dispose();
    _reactionController.dispose();
    super.dispose();
  }
}

class _SettingsSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _SettingsSwitchRenderObjectWidget({
    Key? key,
    required this.value,
    required this.activeColor,
    required this.trackColor,
    required this.thumbColor,
    required this.onChanged,
    required this.textDirection,
    required this.state,
  }) : super(key: key);

  final bool value;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;
  final ValueChanged<bool>? onChanged;
  final _SettingsSwitchState state;
  final TextDirection textDirection;

  @override
  _RenderSettingsSwitch createRenderObject(BuildContext context) {
    return _RenderSettingsSwitch(
      value: value,
      activeColor: activeColor,
      trackColor: trackColor,
      thumbColor: thumbColor,
      onChanged: onChanged,
      textDirection: textDirection,
      state: state,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSettingsSwitch renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..trackColor = trackColor
      ..thumbColor = thumbColor
      ..onChanged = onChanged
      ..textDirection = textDirection;
  }
}

const double _kTrackWidth = 42.0;
const double _kTrackHeight = 24.0;
const double _kTrackRadius = _kTrackHeight / 2.0;
const double _kTrackInnerStart = _kTrackHeight / 2.0;
const double _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
const double _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
const double _kSwitchWidth = 37.0;
const double _kSwitchHeight = 24.0;
// Opacity of a disabled switch, as eye-balled from iOS Simulator on Mac.
const double _kCupertinoSwitchDisabledOpacity = 0.5;

const Duration _kReactionDuration = Duration(milliseconds: 300);
const Duration _kToggleDuration = Duration(milliseconds: 200);

class _RenderSettingsSwitch extends RenderConstrainedBox {
  _RenderSettingsSwitch({
    required bool value,
    required Color activeColor,
    required Color trackColor,
    required Color thumbColor,
    ValueChanged<bool>? onChanged,
    required TextDirection textDirection,
    required _SettingsSwitchState state,
  })  : assert(value != null),
        assert(activeColor != null),
        assert(state != null),
        _value = value,
        _activeColor = activeColor,
        _trackColor = trackColor,
        _thumbPainter = CupertinoThumbPainter.switchThumb(color: thumbColor),
        _onChanged = onChanged,
        _textDirection = textDirection,
        _state = state,
        super(additionalConstraints: const BoxConstraints.tightFor(width: _kSwitchWidth, height: _kSwitchHeight)) {
    state.position.addListener(markNeedsPaint);
    state._reaction.addListener(markNeedsPaint);
  }

  final _SettingsSwitchState _state;

  bool get value => _value;
  bool _value;

  set value(bool value) {
    assert(value != null);
    if (value == _value) return;
    _value = value;
    markNeedsSemanticsUpdate();
  }

  Color get activeColor => _activeColor;
  Color _activeColor;

  set activeColor(Color value) {
    assert(value != null);
    if (value == _activeColor) return;
    _activeColor = value;
    markNeedsPaint();
  }

  Color get trackColor => _trackColor;
  Color _trackColor;

  set trackColor(Color value) {
    assert(value != null);
    if (value == _trackColor) return;
    _trackColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbPainter.color;
  CupertinoThumbPainter _thumbPainter;

  set thumbColor(Color value) {
    if (value == thumbColor) return;
    _thumbPainter = CupertinoThumbPainter.switchThumb(color: value);
    markNeedsPaint();
  }

  ValueChanged<bool>? get onChanged => _onChanged;
  ValueChanged<bool>? _onChanged;
  set onChanged(ValueChanged<bool>? value) {
    if (value == _onChanged) return;
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  bool get isInteractive => onChanged != null;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _state._drag.addPointer(event);
      _state._tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (isInteractive) config.onTap = _state._handleTap;

    config.isEnabled = isInteractive;
    config.isToggled = _value;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _state.position.value;
    final double currentReactionValue = _state._reaction.value;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Paint paint = Paint()..color = Color.lerp(trackColor, activeColor, currentValue)!;

    final Rect trackRect = Rect.fromLTWH(
      offset.dx + (size.width - _kTrackWidth) / 2.0,
      offset.dy + (size.height - _kTrackHeight) / 2.0,
      _kTrackWidth,
      _kTrackHeight,
    );
    final RRect trackRRect = RRect.fromRectAndRadius(trackRect, const Radius.circular(_kTrackRadius));
    canvas.drawRRect(trackRRect, paint);

    final double currentThumbExtension = CupertinoThumbPainter.extension * currentReactionValue;
    final double thumbLeft = lerpDouble(
      trackRect.left + _kTrackInnerStart - 10,
      trackRect.left + _kTrackInnerEnd - 10 - currentThumbExtension,
      visualPosition,
    )!;
    final double thumbRight = lerpDouble(
      trackRect.left + _kTrackInnerStart + 10 + currentThumbExtension,
      trackRect.left + _kTrackInnerEnd + 10,
      visualPosition,
    )!;
    final double thumbCenterY = offset.dy + size.height / 2.0;
    final Rect thumbBounds = Rect.fromLTRB(
      thumbLeft,
      thumbCenterY - 10,
      thumbRight,
      thumbCenterY + 10,
    );

    _clipRRectLayer.layer =
        context.pushClipRRect(needsCompositing, Offset.zero, thumbBounds, trackRRect, (PaintingContext innerContext, Offset offset) {
      _thumbPainter.paint(innerContext.canvas, thumbBounds);
    }, oldLayer: _clipRRectLayer.layer);
  }

  final LayerHandle<ClipRRectLayer> _clipRRectLayer = LayerHandle<ClipRRectLayer>();

  @override
  void dispose() {
    _clipRRectLayer.layer = null;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty('value', value: value, ifTrue: 'checked', ifFalse: 'unchecked', showName: true));
    description.add(FlagProperty('isInteractive', value: isInteractive, ifTrue: 'enabled', ifFalse: 'disabled', showName: true, defaultValue: true));
  }
}
