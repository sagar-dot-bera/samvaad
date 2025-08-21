import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SizeOf {
  static final intance = SizeOf._private();

  SizeOf._private();

  factory SizeOf() {
    return intance;
  }

  double getHight(BuildContext context, double percentage) {
    return MediaQuery.sizeOf(context).height * percentage;
  }

  double getWidth(BuildContext context, double percentage) {
    return MediaQuery.sizeOf(context).width * percentage;
  }
}
