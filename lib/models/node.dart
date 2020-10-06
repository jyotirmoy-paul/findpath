import 'package:findpath/widgets/node_widget.dart';
import 'package:flutter/cupertino.dart';

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

  set changeNodeColor(Color color) =>
      this._key.currentState.setNodeColor(color);
}
