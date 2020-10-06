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
  double factor = 1.0;
  Color color = kDefaultNodeColor;

  setNodeColor(Color newColor) async {
    setState(() {
      factor = kIncreaseByFactor;
    });

    await Future.delayed(kAnimationDuration);

    setState(() {
      factor = 1.0;
      color = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimen = (kNodesDimen - kNodeMargin * 2);

    return Transform.scale(
      scale: factor,
      child: AnimatedContainer(
        duration: kAnimationDuration,
        color: color,
        margin: EdgeInsets.all(kNodeMargin),
        height: dimen,
        width: dimen,
      ),
    );
  }
}
