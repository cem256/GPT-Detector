import 'package:flutter/material.dart';

import 'package:gpt_detector/core/constants/view_constants.dart';

class GPTCard extends StatelessWidget {
  const GPTCard({
    super.key,
    required this.child,
    required this.color,
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
        borderRadius: ViewConstants.borderCircular,
      ),
      child: child,
    );
  }
}
