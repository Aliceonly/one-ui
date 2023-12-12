import 'package:flutter/material.dart';

class OneUiScrollPhysics extends ScrollPhysics {
  final double expandedHeight;

  const OneUiScrollPhysics(this.expandedHeight, {ScrollPhysics? parent})
      : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    assert(ancestor != null);
    return OneUiScrollPhysics(expandedHeight, parent: buildParent(ancestor));
  }

  @override
  createBallisticSimulation(ScrollMetrics position, double velocity) {
    if (velocity != 0.0 ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      return null;
    }
    return null;
  }
}
