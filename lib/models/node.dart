import 'dart:math';

import 'package:findpath/widgets/node_widget.dart';
import 'package:flutter/material.dart';

class Node {
  GlobalKey<NodeWidgetState> _key;
  NodeWidget _nodeWidget;

  Point<int> coord;
  Point<int> parentCoord;
  bool processed;
  double distance;

  Node(int x, int y) {
    this.coord = Point<int>(x, y);
    this.processed = false;
    this.parentCoord = Point<int>(null, null);
    this.distance = double.infinity; // current distance from source node

    this._key = GlobalKey<NodeWidgetState>();
    this._nodeWidget = NodeWidget(
      key: this._key,
      x: x,
      y: y,
    );
  }

  void setNodeColor(Color color) => this._key.currentState.setNodeColor(color);

  Color get nodeColor => this._key.currentState.color;
  Widget get nodeWidget => _nodeWidget;
}
