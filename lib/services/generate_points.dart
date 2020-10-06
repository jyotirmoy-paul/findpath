import 'package:findpath/models/node.dart';
import 'package:findpath/utils/constants.dart';
import 'package:flutter/material.dart';

class GenerateNodes {
  static List<List<Node>> generate(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (size.height < kMinRequiredWidthHeight ||
        size.width < kMinRequiredWidthHeight) return null;

    final int n = (size.height - kAppBarHeight) ~/ kNodesDimen;
    final int m = size.width ~/ kNodesDimen;

    List<List<Node>> cols = List<List<Node>>();

    for (int i = 0; i < n; i++) {
      List<Node> rows = List<Node>();
      for (int j = 0; j < m; j++) rows.add(Node(i, j));
      cols.add(rows);
    }

    return cols;
  }
}
