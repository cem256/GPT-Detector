import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/context_extensions.dart';

class GPTDrawer extends StatelessWidget {
  const GPTDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: context.veryHighValue2x,
                    width: double.infinity,
                    child: Image.asset(
                      Assets.appIcon,
                    ),
                  ),
                  Text(
                    Strings.appName,
                    style: context.textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    Strings.version,
                  ),
                ],
              ),
              SizedBox(
                height: context.mediumValue,
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text(Strings.privacyPolicy),
                onTap: () async => await launchUrlString(mode: LaunchMode.platformDefault, Strings.privacyPolicyUrl),
              ),
              ExpansionTile(
                leading: const Icon(Icons.info),
                title: const Text(Strings.drawerInfo),
                childrenPadding: context.paddingAllDefault,
                expandedAlignment: Alignment.centerLeft,
                children: const [
                  Text(
                    Strings.drawerInfoText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
