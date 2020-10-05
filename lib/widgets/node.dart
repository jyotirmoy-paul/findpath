import 'package:findpath/utils/constants.dart';
import 'package:flutter/material.dart';

class Node extends StatefulWidget {
  final int x;
  final int y;

  Node({
    @required this.x,
    @required this.y,
  });

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  double factor = 1.0;
  Color color = kGray;

  // long tap is used to set the end (green coloured)
  _onDoubleTap() async {
    setState(() {
      factor = kIncreaseByFactor;
      color = color == kGray ? kGreen : kGray;
    });

    await Future.delayed(kAnimationDuration);

    setState(() {
      factor = 1.0;
    });
  }

  // on long press is used to set the start (red coloured)
  _onLongPress() async {
    setState(() {
      factor = kIncreaseByFactor;
      color = color == kGray ? kRed : kGray;
    });

    await Future.delayed(kAnimationDuration);

    setState(() {
      factor = 1.0;
    });
  }

  // on tap used for creating blocks
  _onTap() async {
    setState(() {
      factor = kIncreaseByFactor;
      color = color == kGray ? kDarkGray : kGray;
    });

    await Future.delayed(kAnimationDuration);

    setState(() {
      factor = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimen = (kNodesDimen - kNodeMargin * 2);

    return Transform.scale(
      scale: factor,
      child: GestureDetector(
        onDoubleTap: _onDoubleTap,
        onLongPress: _onLongPress,
        onTap: _onTap,
        child: AnimatedContainer(
          duration: kAnimationDuration,
          color: color,
          margin: EdgeInsets.all(kNodeMargin),
          height: dimen,
          width: dimen,
        ),
      ),
    );
  }
}
