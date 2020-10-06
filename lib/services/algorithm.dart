import 'dart:developer';

import 'package:findpath/models/node.dart';
import 'dart:math' as math;

import 'package:findpath/utils/constants.dart';

// this class contains the Dijkstras Algorithm for finding the shortest path between the start node and the end node
class Algorithm {
  static Future<void> delay() => Future.delayed(kAlgorithmAnimationDuration);

  static double getDistance(Node nodeA, Node nodeB) {
    int x1 = nodeA.nodeColor.red;
    int y1 = nodeA.nodeColor.green;
    int z1 = nodeA.nodeColor.blue;

    int x2 = nodeB.nodeColor.red;
    int y2 = nodeB.nodeColor.green;
    int z2 = nodeB.nodeColor.blue;

    // as Dijkstras algorithm works on non-zero distances, we need a min distance of 0.01
    return 0.01 +
        math.pow(x1 - x2, 2) +
        math.pow(y1 - y2, 2) +
        math.pow(z1 - z2, 2);
  }

  static List<Node> getNeighbours(List<List<Node>> nodes, int x, int y) {
    List<Node> neighbors = List<Node>();

    int n = nodes.length;
    int m = nodes[0].length;

    if (x > 0 && !nodes[x - 1][y].processed) neighbors.add(nodes[x - 1][y]);
    if (x < n - 1 && !nodes[x + 1][y].processed) neighbors.add(nodes[x + 1][y]);
    if (y > 0 && !nodes[x][y - 1].processed) neighbors.add(nodes[x][y - 1]);
    if (y < m - 1 && !nodes[x][y + 1].processed) neighbors.add(nodes[x][y + 1]);

    return neighbors;
  }

  // todo: this is not a ACTUAL heapify function, but can be later implemented
  // FIXME: the current implementation has an complexity of O(n) which can be improved to O(logN)
  static void heapify(List<Node> queue) {
    double minDistance = double.infinity;
    int minIndex = -1;

    for (int i = 0; i < queue.length; i++) {
      if (queue[i].distance < minDistance) {
        minDistance = queue[i].distance;
        minIndex = i;
      }
    }

    assert(minIndex != -1);

    Node temp = queue[0];
    queue[0] = queue[minIndex];
    queue[minIndex] = temp;
  }

  static Future<void> drawPath(List<List<Node>> nodes, Node node) async {
    while (node.parentCoord.x != null) {
      if (node.nodeColor != kStartNodeColor) node.setNodeColor(kPathColor);

      await Algorithm.delay();
      node = nodes[node.parentCoord.x][node.parentCoord.y];
    }
  }

  static Future<void> run({
    Node startNode,
    Node endNode,
    List<List<Node>> nodes,
  }) async {
    assert(startNode != null);
    assert(endNode != null);
    assert(nodes != null);

    // initialize the source as 0
    startNode.distance = 0;

    // todo: use a min heap to get the min distance value first
    List<Node> queue = nodes.expand((e) => e).toList();

    while (queue.length > 0) {
      heapify(queue);
      Node u = queue.removeAt(0);

      u.processed = true;
      if (u.nodeColor != kStartNodeColor) u.setNodeColor(kProcessedNodeColor);

      await Algorithm.delay();

      List<Node> neighbours =
          Algorithm.getNeighbours(nodes, u.coord.x, u.coord.y);

      for (Node v in neighbours) {
        // check if v is our target node
        if (v.nodeColor == kEndNodeColor) {
          // make the path and return from this function
          return Algorithm.drawPath(nodes, u);
        }

        double dist = Algorithm.getDistance(u, v);

        v.setNodeColor(kNeighboursNodeColor);

        if (u.distance + dist < v.distance) {
          v.distance = u.distance + dist;
          v.parentCoord = u.coord; // to keep track of the shortest path
        }

        await Algorithm.delay();
      }

      await Algorithm.delay();
    }
  }
}
