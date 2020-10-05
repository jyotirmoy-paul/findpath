import 'package:findpath/engine/generate_points.dart';
import 'package:findpath/utils/constants.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<List<Widget>> nodes;

  _startAlgo() {}

  Widget _buildLeadingPlayIconButton() => IconButton(
        icon: Icon(
          Icons.play_arrow,
          size: 30.0,
          color: kGreen,
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
    nodes = GenerateNodes.generate(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kAppBarHeight),
        child: AppBar(
          backgroundColor: kGray,
          elevation: 0.0,
          centerTitle: true,
          title: _buildTitleText(),
          leading: _buildLeadingPlayIconButton(),
        ),
      ),
      body: SafeArea(
        child: nodes == null
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
                children: nodes
                    .map(
                      (widgets) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widgets,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
