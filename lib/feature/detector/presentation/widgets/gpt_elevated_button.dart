import 'package:flutter/material.dart';

import 'package:gpt_detector/core/extensions/context_extensions.dart';

class GPTElevatedButton extends StatelessWidget {
  const GPTElevatedButton({
    required this.child,
    this.onPressed,
    super.key,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: context.defaultBorderRadius,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
