import 'package:flutter/material.dart';

import 'package:gpt_detector/core/extensions/context_extensions.dart';

class GPTAppBar extends StatelessWidget with PreferredSizeWidget {
  const GPTAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: context.defaultRadius,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
