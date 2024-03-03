import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_detector/app/constants/asset_constants.dart';
import 'package:gpt_detector/app/constants/string_constants.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/app/theme/cubit/theme_cubit.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';
import 'package:gpt_detector/core/utils/package_info/package_info_utils.dart';
import 'package:gpt_detector/core/utils/rate_app/rate_app.dart';
import 'package:gpt_detector/core/utils/share_app/share_app.dart';
import 'package:gpt_detector/core/utils/url_launcher/url_launcher.dart';

class GPTDrawer extends StatelessWidget {
  const GPTDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: context.paddingAllDefault,
            child: Column(
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          AssetConstants.appIcon,
                          height: context.veryHighValue2x,
                          width: double.infinity,
                        ),
                        IconButton(
                          icon: Icon(context.brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode),
                          onPressed: () => context.read<ThemeCubit>().changeTheme(brightness: context.brightness),
                        ),
                      ],
                    ),
                    Text(
                      StringConstants.appName,
                      style: context.textTheme.bodyLarge,
                    ),
                    Text(
                      context.l10n.version(PackageInfoUtils.getAppVersion()),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.defaultValue,
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(context.l10n.privacyPolicy),
                  onTap: () async => UrlLauncherUtils.launchUrlFromString(url: StringConstants.privacyPolicyUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(context.l10n.drawerRateUs),
                  onTap: () async => RateAppUtils.rateApp(),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: Text(context.l10n.drawerShareApp),
                  onTap: () async => ShareAppUtils.shareApp(),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(context.l10n.contribute),
                  onTap: () async => UrlLauncherUtils.launchUrlFromString(url: StringConstants.githubUrl),
                ),
                ExpansionTile(
                  leading: const Icon(Icons.smartphone),
                  title: Text(context.l10n.drawerDiscoverMoreApps),
                  initiallyExpanded: true,
                  children: [
                    ListTile(
                      onTap: () async =>
                          UrlLauncherUtils.launchUrlFromString(url: StringConstants.passwordGeneratorPlayStoreUrl),
                      leading: Image.asset(
                        AssetConstants.passwordGeneratorIcon,
                        height: 24,
                      ),
                      title: const Text(StringConstants.passwordGenerator),
                      subtitle: Text(context.l10n.passwordGeneratorDescription),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
