import 'package:findpath/screens/main_screen.dart';
import 'package:findpath/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final Function algoStart;
  final Function clearAll;
  final Function updateNodeType;
  final Function updateAnimationPref;

  CustomAppBar({
    @required this.algoStart,
    @required this.clearAll,
    @required this.updateNodeType,
    @required this.updateAnimationPref,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  NodeType _currentNodeType = NodeType.BlockNode;
  bool _isPlaying = false;
  bool _showAnimation = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: _buildTitleText(),
      leading: _buildLeadingPlayIconButton(),
      actions: _buildActions(),
    );
  }

  Widget _buildButton(
    IconData iconData,
    NodeType nodeType,
  ) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: _currentNodeType == nodeType ? kDefaultNodeColor : null,
      child: IconButton(
        splashRadius: 30.0,
        iconSize: 24.0,
        color: _isPlaying ? Colors.black12 : Colors.black,
        icon: Icon(iconData),
        onPressed: _isPlaying
            ? null
            : () {
                widget.updateNodeType(nodeType);
                setState(() {
                  _currentNodeType = nodeType;
                });
              },
      ),
    );
  }

  List<Widget> _buildActions() => [
        IconButton(
          icon: Icon(
            _showAnimation ? Icons.timer : Icons.timer_off,
            size: 30.0,
            color: _isPlaying ? Colors.black12 : Colors.black,
          ),
          onPressed: _isPlaying
              ? null
              : () {
                  setState(() {
                    _showAnimation = !_showAnimation;
                  });
                  widget.updateAnimationPref(_showAnimation);
                },
        ),

        const SizedBox(width: 10.0),

        IconButton(
          icon: Icon(
            Icons.history,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _currentNodeType = NodeType.BlockNode;
              _isPlaying = false;
              _showAnimation = true;
              widget.updateAnimationPref(_showAnimation);
            });
            widget.clearAll(context);
          },
        ),

        //  separator
        const SizedBox(width: 50.0),

        /* node modifiers */
        _buildButton(
          Icons.clear,
          NodeType.ClearNode,
        ),
        _buildButton(
          Icons.add_location,
          NodeType.StartNode,
        ),
        _buildButton(
          Icons.pin_drop,
          NodeType.EndNode,
        ),
        _buildButton(
          Icons.block,
          NodeType.BlockNode,
        ),
      ];

  Widget _buildLeadingPlayIconButton() => IconButton(
        icon: Icon(
          Icons.play_arrow,
          size: 30.0,
          color: _isPlaying ? Colors.green.shade100 : Colors.green,
        ),
        onPressed: _isPlaying
            ? null
            : () {
                setState(() => _isPlaying = true);
                widget.algoStart(context, (bool value) {
                  setState(() => _isPlaying = value);
                });
              },
      );

  Widget _buildTitleText() => const Text(
        "Find Path - Dijkstras Algorithm",
        style: const TextStyle(
          color: Colors.black,
        ),
      );
}
