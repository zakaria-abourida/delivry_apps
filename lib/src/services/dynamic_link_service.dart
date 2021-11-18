import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:package_info/package_info.dart';
import '../repository/settings_repository.dart' as settingRepo;

class DynamicLinksService {
  static Future<String> createDynamicLink(String parameter) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName);
    String uriPrefix = "https://webiliapp.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://www.webilli.ma/$parameter'),
      androidParameters: AndroidParameters(
        packageName: 'com.webiliapp.food_delivery_app',
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.webiliapp.fooddeliveryapp',
        minimumVersion: packageInfo.version,
        appStoreId: '1546784996',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //     title: 'Example of a Dynamic Link',
      //     description: 'This link works whether app is installed or not!',
      //     imageUrl: Uri.parse(
      //         "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")),
    );

    // final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDynamicLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  static _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('_handleDynamicLink | deeLink: $deepLink');
    }
    if (deepLink.pathSegments.contains('navToKFc')) {
      var title = deepLink.queryParameters['code'];
      if (title != null) {
        // print("refercode=$title");
        settingRepo.navigatorKey.currentState
            .pushReplacementNamed('/Menu', arguments: 1);
      }
    }
  }
}

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class DynamicLinkService {
//   Future handleDynamicLinks() async {
//     final PendingDynamicLinkData data =
//         await FirebaseDynamicLinks.instance.getInitialLink();

//     _handleDeepLink(data);
//     FirebaseDynamicLinks.instance.onLink(
//         onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
//       _handleDeepLink(dynamicLinkData);
//     }, onError: (OnLinkErrorException e) async {
//       print('Dynamic Link Failed: ${e.message}');
//     });
//   }

//   void _handleDeepLink(PendingDynamicLinkData data) {
//     final Uri deepLink = data?.link;
//     if (deepLink != null) {
//       print('_handleDeepLink | deepLink $deepLink');
//     }
//   }
// }
