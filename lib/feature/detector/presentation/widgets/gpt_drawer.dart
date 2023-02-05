import 'package:flutter/material.dart';
import 'package:gpt_detector/app/constants/assets.dart';
import 'package:gpt_detector/app/constants/strings.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
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
                    context.l10n.appName,
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    context.l10n.version,
                  ),
                ],
              ),
              SizedBox(
                height: context.mediumValue,
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: Text(context.l10n.privacyPolicy),
                onTap: () async => launchUrlString(Strings.privacyPolicyUrl),
              ),
              ExpansionTile(
                leading: const Icon(Icons.info),
                title: Text(context.l10n.drawerInfo),
                childrenPadding: context.paddingAllDefault,
                expandedAlignment: Alignment.centerLeft,
                children: [Text(context.l10n.drawerInfoDetail)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
