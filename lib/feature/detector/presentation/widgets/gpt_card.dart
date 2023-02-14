import 'package:flutter/material.dart';

class GPTCard extends StatelessWidget {
  const GPTCard({
    required this.child,
    required this.color,
    super.key,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: child,
    );
  }
}
