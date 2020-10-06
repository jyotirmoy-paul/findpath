import 'package:findpath/widgets/node_widget.dart';
import 'package:flutter/material.dart';

class Node {
  GlobalKey<NodeWidgetState> _key;
  NodeWidget nodeWidget;

  Node(int x, int y) {
    this._key = GlobalKey<NodeWidgetState>();
    this.nodeWidget = NodeWidget(
      key: this._key,
      x: x,
      y: y,
    );
  }

  void setNodeColor(Color color) => this._key.currentState.setNodeColor(color);

  Color get nodeColor => this._key.currentState.color;
}
