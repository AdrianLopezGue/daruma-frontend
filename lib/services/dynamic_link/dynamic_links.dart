import 'package:daruma/ui/widget/select-member-in-group-dialog.widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class AppDynamicLinks {
  static void initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null && deepLink.queryParameters != null) {
      final type = deepLink.queryParameters['groupid'] ?? '';
      print("Created:" + type);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLink) async {
          final deepLink = dynamicLink?.link;

          if (deepLink != null && deepLink.queryParameters != null) {
            final type = deepLink.queryParameters['groupid'] ?? '';
            print("Opened:" + type);
            if (type != '') {
              showDialog(
                  context: context,
                  builder: (_) {
                    return new SimpleDialog(
                      title: new Text("¿Quién eres?"),
                      children: <Widget>[
                      SelectMemberInGroupDialog(groupId: type),
                    ]);
                  });
            }
          }
        },
        onError: (e) async {});
  }

  Future<String> createDynamicLink(String groupId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://daruma.page.link/',
      link: Uri.parse('https://daruma.page.link/?groupid=$groupId'),
      androidParameters: AndroidParameters(
        packageName: 'com.tfg.daruma',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    return shortLink.shortUrl.toString();
  }
}
