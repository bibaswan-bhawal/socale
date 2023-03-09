import 'package:flutter/material.dart';

const Curve emphasized = Cubic(0.20, 0.00, 0.00, 1.00);

const Curve emphasizedDecelerate = Cubic(0.05, 0.70, 0.10, 1.00);
const Curve emphasizedAccelerate = Cubic(0.30, 0.00, 0.80, 0.15);

class FlippedCurveTween extends CurveTween {
  FlippedCurveTween({required super.curve});

  @override
  double transform(double t) => 1.0 - super.transform(t);
}
