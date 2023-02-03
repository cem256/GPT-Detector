import 'package:flutter/material.dart';

import '../../../../core/constants/view_constants.dart';

class GPTElevatedButton extends StatelessWidget {
  const GPTElevatedButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: ViewConstants.borderCircular,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
