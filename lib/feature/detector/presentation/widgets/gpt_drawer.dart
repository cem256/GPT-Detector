import 'package:flutter/material.dart';
import 'package:gpt_detector/core/constants/assets.dart';
import 'package:gpt_detector/core/constants/strings.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                  Image.asset(
                    Assets.appIcon,
                    height: context.veryHighValue2x,
                    width: double.infinity,
                  ),
                  Text(
                    Strings.appName,
                    style: context.textTheme.bodyLarge,
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
                onTap: () async => launchUrlString(Strings.privacyPolicyUrl),
              ),
              ExpansionTile(
                leading: const Icon(Icons.info),
                title: const Text(Strings.drawerInfo),
                childrenPadding: context.paddingAllDefault,
                expandedAlignment: Alignment.centerLeft,
                children: const [
                  Text(Strings.drawerInfoText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
