import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/providers/providers.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<String> _text = [];
  Offset _position = Offset.zero;
  WidgetRef? ref;
  bool _isDragging = false;
  Size _screenSize = Size.zero;
  double _angle = 0;

  List<String> get text => _text;
  Offset get position => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
  }

  void setRef(WidgetRef ref) {
    this.ref = ref;
  }

  void setScreenSize(Size screenSize) {
    _screenSize = screenSize;
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x = _position.dx;

    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus();

    switch (status) {
      case CardStatus.like:
        print("like");
        like();
        return;
      case CardStatus.dislike:
        print("dislike");
        dislike();
        return;
      default:
        _position = Offset.zero;
        _angle = 0;
        break;
    }

    notifyListeners();
  }

  Future _nextCard() async {
    if (ref != null) {
      final matchesProvider = ref!.watch(matchAsyncController);
      if (matchesProvider.value!.isEmpty) return;
      print("remove");
      await Future.delayed(Duration(milliseconds: 200));
      ref!.read(matchAsyncController.notifier).removeMatch();
      notifyListeners();
      resetPosition();
    }
  }

  void like() {
    _angle = 20;
    _position += Offset(_screenSize.width / 2, 0);
    _nextCard();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(_screenSize.width / 2, 0);
    _nextCard();
  }

  CardStatus? getStatus() {
    final x = _position.dx;

    const delta = 100;

    if (x >= delta) {
      return CardStatus.like;
    } else if (x <= -delta) {
      return CardStatus.dislike;
    }

    return null;
  }

  void getMatches() {}

  void resetUsers() {
    _text = <String>[
      'Volcanicvine',
      'BOB',
      'BIB',
      'BIBOB',
      'BIBITYBOBITYBOO',
    ].reversed.toList();

    notifyListeners();
  }

  void resetPosition() {
    _angle = 0;
    _position = Offset(0, 0);
    notifyListeners();
  }
}
