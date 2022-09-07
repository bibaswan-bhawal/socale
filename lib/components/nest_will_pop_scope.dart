import 'package:flutter/material.dart';

class NestedWillPopScope extends StatefulWidget {
  final WillPopCallback onWillPop;
  final Widget child;

  const NestedWillPopScope({
    Key? key,
    required this.onWillPop,
    required this.child,
  }) : super(key: key);

  @override
  _NestedWillPopScopeState createState() => _NestedWillPopScopeState();

  static _NestedWillPopScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NestedWillPopScopeState>();
  }
}

class _NestedWillPopScopeState extends State<NestedWillPopScope> {
  ModalRoute<dynamic>? _route;

  _NestedWillPopScopeState? _descendant;
  _NestedWillPopScopeState? get descendant => _descendant;
  set descendant(_NestedWillPopScopeState? state) {
    _descendant = state;
    updateRouteCallback();
  }

  Future<bool> onWillPop() async {
    bool? willPop;
    if (_descendant != null) {
      willPop = await _descendant!.onWillPop();
    }
    if (willPop == null || willPop) {
      willPop = await widget.onWillPop();
    }
    return willPop;
  }

  void updateRouteCallback() {
    _route?.removeScopedWillPopCallback(onWillPop);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(onWillPop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var parentGuard = NestedWillPopScope.of(context);
    if (parentGuard != null) {
      parentGuard.descendant = this;
    }
    updateRouteCallback();
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
