import 'dart:developer';

import 'package:findpath/engine/generate_points.dart';
import 'package:findpath/models/node.dart';
import 'package:findpath/utils/constants.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<List<Node>> _nodes;

  _startAlgo() {}

  // this method handles the node tap at index (i, j)
  void _onNodeTap(int i, int j) {
    log('($i, $j)');
  }

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

  @override
  Widget build(BuildContext context) {
    _nodes = GenerateNodes.generate(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kAppBarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: _buildTitleText(),
          leading: _buildLeadingPlayIconButton(),
        ),
      ),
      body: SafeArea(
        child: _nodes == null
            ? Center(
                child: Text(
                  'Too Small Dimensions',
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
