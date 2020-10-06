import 'package:findpath/utils/constants.dart';
import 'package:flutter/material.dart';

class NodeWidget extends StatefulWidget {
  final int x;
  final int y;

  NodeWidget({
    Key key,
    @required this.x,
    @required this.y,
  }) : super(key: key);

  @override
  NodeWidgetState createState() => NodeWidgetState();
}

class NodeWidgetState extends State<NodeWidget> {
  double _factor = 1.0;
  Color _color = kDefaultNodeColor;

  Color get color => _color;

  setNodeColor(Color newColor) async {
    setState(() {
      _factor = kIncreaseByFactor;
      _color = newColor;
    });

    await Future.delayed(kAnimationDuration);

    setState(() {
      _factor = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimen = (kNodesDimen - kNodeMargin * 2);

    return Transform.scale(
      scale: _factor,
      child: AnimatedContainer(
        duration: kAnimationDuration,
        color: _color,
        margin: EdgeInsets.all(kNodeMargin),
        height: dimen,
        width: dimen,
      ),
    );
  }
}
