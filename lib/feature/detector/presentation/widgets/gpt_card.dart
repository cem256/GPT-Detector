import 'package:flutter/material.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

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
      elevation: 4,
      margin: EdgeInsets.zero,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: context.defaultBorderRadius,
      ),
      child: child,
    );
  }
}
