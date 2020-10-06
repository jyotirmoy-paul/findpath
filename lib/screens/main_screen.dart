import 'package:findpath/services/algorithm.dart';
import 'package:findpath/services/generate_points.dart';
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

  _startAlgo() async {
    // todo: after the algorithm starts, no modification in the playground would be possible

    // todo: look out for empty start or end node

    await Algorithm.run(
      startNode: _startNode,
      endNode: _endNode,
      nodes: _nodes,
    );
  }

  void _updateNodeType(NodeType nodeType, BuildContext ctx) {
    if (_currentSelectedNodeType == nodeType) return;

    _currentSelectedNodeType = nodeType;

    switch (nodeType) {
      case NodeType.BlockNode:
        return Alert.showSnackBar(ctx, 'Block node selected');
      case NodeType.StartNode:
        return Alert.showSnackBar(ctx, 'Start node selected');
      case NodeType.EndNode:
        return Alert.showSnackBar(ctx, 'End node selected');
      case NodeType.ClearNode:
        return Alert.showSnackBar(ctx, 'Clear node selected');
    }
  }

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

    if (mounted) setState(() {});

    Alert.showSnackBar(ctx, 'Cleared all Nodes');
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
        child: Builder(
          builder: (ctx) => AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            title: _buildTitleText(),
            leading: _buildLeadingPlayIconButton(),
            actions: _buildActions(ctx),
          ),
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

  List<Widget> _buildActions(BuildContext ctx) => [
        IconButton(
          icon: Icon(
            Icons.highlight_off,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => _clearNodes(ctx),
        ),
        IconButton(
          icon: Icon(
            Icons.clear,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => _updateNodeType(NodeType.ClearNode, ctx),
        ),
        IconButton(
          icon: Icon(
            Icons.add_location,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => _updateNodeType(NodeType.StartNode, ctx),
        ),
        IconButton(
          icon: Icon(
            Icons.pin_drop,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => _updateNodeType(NodeType.EndNode, ctx),
        ),
        IconButton(
          icon: Icon(
            Icons.block,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () => _updateNodeType(NodeType.BlockNode, ctx),
        ),
      ];

  Widget _buildLeadingPlayIconButton() => IconButton(
        icon: Icon(
          Icons.play_arrow,
          size: 30.0,
          color: Colors.green,
        ),
        onPressed: _startAlgo,
      );

  Widget _buildTitleText() => const Text(
        "Find Path",
        style: const TextStyle(
          color: Colors.black,
        ),
      );
}
