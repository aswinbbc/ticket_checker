import 'package:flutter/material.dart';

class ListScrollMoreWidget extends StatelessWidget {
  final ListView child;
  final void Function(BuildContext context) onLoadMore;
  final bool Function(BuildContext context) canLoadMore;

  ListScrollMoreWidget({
    Key? key,
    required this.child,
    required this.onLoadMore,
    required this.canLoadMore,
  })  : assert(child.controller != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            if (canLoadMore(context)) onLoadMore(context);
          }
          return true;
        },
        child: child);
  }
}

class GridScrollMoreWidget extends StatelessWidget {
  final GridView child;
  final void Function(BuildContext context) onLoadMore;
  final bool Function(BuildContext context) canLoadMore;

  GridScrollMoreWidget({
    Key? key,
    required this.child,
    required this.onLoadMore,
    required this.canLoadMore,
  })  : assert(child.controller != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            if (canLoadMore(context)) onLoadMore(context);
          }
          return true;
        },
        child: child);
  }
}
