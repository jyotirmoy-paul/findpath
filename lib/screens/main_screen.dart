import 'package:findpath/screens/custom_app_bar.dart';
import 'package:findpath/services/algorithm.dart';
import 'package:findpath/services/generate_nodes.dart';
import 'package:findpath/models/node.dart';
import 'package:findpath/utils/alert.dart';
import 'package:findpath/utils/constants.dart';
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

  _startAlgo(BuildContext ctx, Function setIsPlaying) async {
    if (_startNode == null || _endNode == null) {
      setIsPlaying(false);
      return Alert.showSnackBar(ctx, 'You must select a start and end node');
    }

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

    if (mounted) setState(() {});

    Alert.showSnackBar(ctx, 'Reset');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nodes = GenerateNodes.generate(context);

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
      body: SafeArea(
        child: _nodes == null
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
            : Column(
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
