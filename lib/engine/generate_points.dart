import 'package:findpath/utils/constants.dart';
import 'package:findpath/widgets/node.dart';
import 'package:flutter/material.dart';

class GenerateNodes {
  static List<List<Widget>> generate(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (size.height < 100.0 || size.width < 100.0) return null;

    final int n = (size.height - kAppBarHeight) ~/ kNodesDimen;
    final int m = size.width ~/ kNodesDimen;

    List<List<Widget>> cols = List<List<Widget>>();

    for (int i = 0; i < n; i++) {
      List<Widget> rows = List<Widget>();
      for (int j = 0; j < m; j++) rows.add(Node(x: i, y: j));

      cols.add(rows);
    }

    return cols;
  }
}
