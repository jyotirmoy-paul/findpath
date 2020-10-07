import 'dart:developer';

import 'package:findpath/screens/custom_app_bar.dart';
import 'package:findpath/services/algorithm.dart';
import 'package:findpath/services/generate_nodes.dart';
import 'package:findpath/models/node.dart';
import 'package:findpath/utils/alert.dart';
import 'package:findpath/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NodeType {
  BlockNode,
  StartNode,
  EndNode,
  ClearNode,
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<List<Node>> _nodes;
  NodeType _currentSelectedNodeType = NodeType.BlockNode;

  Node _startNode;
  Node _endNode;

  bool _showAnimation = true;
  bool _isShowing = false;

  double xOffset = 0.0;
  double yOffset = 0.0;

  _startAlgo(BuildContext ctx, Function setIsPlaying) async {
    if (_startNode == null || _endNode == null) {
      setIsPlaying(false);
      return Alert.showSnackBar(ctx, 'You must select a start and end node');
    }

    _isShowing = true;

    try {
      await Algorithm.run(
        startNode: _startNode,
        endNode: _endNode,
        nodes: _nodes,
        showAnimation: _showAnimation,
      );
    } catch (e) {
      print(e);
    }

    Alert.showSnackBar(ctx, 'Done');
  }

  void _updateNodeType(NodeType nodeType) =>
      _currentSelectedNodeType = nodeType;

  void _onNodeTap(int i, int j) {
    if (_isShowing) return;

    switch (_currentSelectedNodeType) {
      case NodeType.BlockNode:
        if (_nodes[i][j].nodeColor != kDefaultNodeColor) return;

        return _nodes[i][j].setNodeColor(kBlockNodeColor);

      case NodeType.StartNode:
        if (_nodes[i][j].nodeColor != kDefaultNodeColor) return;
        if (_startNode != null) return;

        _startNode = _nodes[i][j];
        return _nodes[i][j].setNodeColor(kStartNodeColor);

      case NodeType.EndNode:
        if (_nodes[i][j].nodeColor != kDefaultNodeColor) return;
        if (_endNode != null) return;

        _endNode = _nodes[i][j];
        return _nodes[i][j].setNodeColor(kEndNodeColor);

      case NodeType.ClearNode:
        if (_nodes[i][j].nodeColor == kStartNodeColor) _startNode = null;
        if (_nodes[i][j].nodeColor == kEndNodeColor) _endNode = null;

        return _nodes[i][j].setNodeColor(kDefaultNodeColor);
    }
  }

  void _clearNodes(BuildContext ctx) {
    _nodes.clear();
    _nodes.addAll(GenerateNodes.generate(context));
    _startNode = null;
    _endNode = null;
    _isShowing = false;

    if (mounted) setState(() {});

    Alert.showSnackBar(ctx, 'Reset');
  }

  // this method taps the (x, y) point from the Global Position Offset value (as passed in the DragUpdateDetails)
  void _tapNode(DragUpdateDetails dragUpdateDetails) {
    int x = -1;
    int y = -1;

    double xPos = dragUpdateDetails.localPosition.dx;
    double yPos = dragUpdateDetails.localPosition.dy;

    // searching for the x value
    for (int i = 0; i < _nodes[0].length; i++) {
      final c = kNodesDimen * i + i - i * kNodeMargin + xOffset;

      double start = c;
      double end = c + kNodesDimen;

      // if xPos is contained in the range, then our x is i
      if (start < xPos && xPos < end) {
        x = i;
        break;
      }
    }

    // searching for the y value
    for (int i = 0; i < _nodes.length; i++) {
      final c = kNodesDimen * i + i - i * kNodeMargin + yOffset;

      double start = c;
      double end = c + kNodesDimen;

      // if xPos is contained in the range, then our x is i
      if (start < yPos && yPos < end) {
        y = i;
        break;
      }
    }

//    log('($x, $y)');

    if (x != -1 && y != -1) _onNodeTap(y, x);
  }

  @override
  Widget build(BuildContext context) {
    _nodes = GenerateNodes.generate(context);

    print('(${_nodes[0].length}, ${_nodes.length})');

    xOffset =
        (MediaQuery.of(context).size.width - (kNodesDimen * _nodes[0].length)) /
            2;

    print('xOffset: $xOffset');

    yOffset = ((MediaQuery.of(context).size.height - kAppBarHeight) -
            (kNodesDimen * _nodes.length)) /
        2;

    print('yOffset: $yOffset');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kAppBarHeight),
        child: CustomAppBar(
          clearAll: _clearNodes,
          algoStart: _startAlgo,
          updateNodeType: _updateNodeType,
          updateAnimationPref: (value) => _showAnimation = value,
        ),
      ),
      body: _nodes == null
          ? Center(
              child: Text(
                'Too small window size',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : GestureDetector(
              onHorizontalDragUpdate: _tapNode,
              onVerticalDragUpdate: _tapNode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _nodes
                    .asMap()
                    .entries
                    .map(
                      (widgets) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widgets.value
                            .asMap()
                            .entries
                            .map(
                              (node) => GestureDetector(
                                onTap: () => _onNodeTap(widgets.key, node.key),
                                child: node.value.nodeWidget,
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
