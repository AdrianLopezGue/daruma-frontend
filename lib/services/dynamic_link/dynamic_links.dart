import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AppDynamicLinks {
  static void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null && deepLink.queryParameters != null) {
      final type = deepLink.queryParameters['groupId'] ?? '';
      print(type);
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      final deepLink = dynamicLink?.link;

      if (deepLink != null && deepLink.queryParameters != null) {
       final type = deepLink.queryParameters['groupId'] ?? '';
       print(type);
      }
    }, onError: (e) async {
      print(e);
    });
  }

  Future<String> createDynamicLink(String groupId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://daruma.page.link/',
      link: Uri.parse('https://daruma.page.link/?idgroup=$groupId'),
      androidParameters: AndroidParameters(
        packageName: 'io.flutter.plugins.firebasedynamiclinksexample',
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

    Uri url;
    
    //final ShortDynamicLink shortLink = await parameters.buildShortLink();
    //url = shortLink.shortUrl;

    url = await parameters.buildUrl();

    return url.toString();
  }
}
