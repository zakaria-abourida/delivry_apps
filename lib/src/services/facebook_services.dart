import 'dart:developer';

import 'package:facebook_app_events/facebook_app_events.dart';

class FacebookEventsService {
  static final intsance = FacebookAppEvents();

  static Future<void> activeApp() async {
    await intsance.logActivatedApp();
  }

  static Future<void> logSearchedEvent(String searchString) async {
    Map<String, dynamic> params = {};

    params.addAll({FacebookAppEvents.paramNameContentType: 'Food'});
    params.addAll({'Mot clé': searchString});
    await intsance.logEvent(name: 'La recherche', parameters: params);
    log('Search events succes');
  }

  static Future<void> viewPlat(String contentName, String contentId,
      double price, String restaurant) async {
    Map<String, dynamic> params = {};

    params.addAll({FacebookAppEvents.paramNameContentType: 'Food'});
    params.addAll({FacebookAppEvents.paramNameContent: contentName});
    params.addAll({FacebookAppEvents.paramNameContentId: contentId});
    params.addAll({FacebookAppEvents.paramNameCurrency: 'MAD'});
    params.addAll({'Restaurant': restaurant});

    await intsance.logEvent(
        name: 'Voir plat', parameters: params, valueToSum: price);
    log('view plats succes');
  }

  static Future<void> addPlatToFavoriteEvent(String contentName,
      String contentId, double price, String restaurant) async {
    Map<String, dynamic> params = {};

    params.addAll({FacebookAppEvents.paramNameContentType: 'Food'});
    params.addAll({FacebookAppEvents.paramNameContent: contentName});
    params.addAll({FacebookAppEvents.paramNameContentId: contentId});
    params.addAll({FacebookAppEvents.paramNameCurrency: 'MAD'});
    params.addAll({'Restaurant': restaurant});

    await intsance.logEvent(
        name: 'Add Plat to favorite', parameters: params, valueToSum: price);
    log('fav plats succes');
  }

  static Future<void> addToCart(String contentName, String contentId,
      double price, String restaurant) async {
    Map<String, dynamic> params = {};

    params.addAll({FacebookAppEvents.paramNameContentType: 'Food'});
    params.addAll({FacebookAppEvents.paramNameContent: contentName});
    params.addAll({FacebookAppEvents.paramNameContentId: contentId});
    params.addAll({FacebookAppEvents.paramNameCurrency: 'MAD'});
    params.addAll({'Restaurant': restaurant});

    await intsance.logEvent(
        name: 'Ajouter au panier', parameters: params, valueToSum: price);
    log('fav plats succes');
  }
}
