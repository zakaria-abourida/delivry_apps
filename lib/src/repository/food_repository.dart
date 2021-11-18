import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/favorite.dart';
import '../models/filter.dart';
import '../models/food.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import '../services/crashlytics_service.dart';

Future<Stream<Food>> getTrendingFoods(Address address) async {
  try {
    Uri uri =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}foods');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    filter.delivery = false;
    filter.open = false;
    _queryParams['limit'] = '6';
    _queryParams['trending'] = 'week';
    if (!address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFood(String foodId) async {
  try {
    Uri uri = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}foods/$foodId');
    uri = uri.replace(queryParameters: {
      'with':
          'nutrition;restaurant;category;extras;extraGroups;foodReviews;foodReviews.user'
    });
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) {
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> searchFoodsOfRestaurant(
    String search, Address address, String restaurant_id) async {
  try {
    Uri uri =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}foods');
    Map<String, dynamic> _queryParams = {};

    _queryParams['restaurant_id'] = '$restaurant_id';
    _queryParams['search_value'] = '$search';

    // _queryParams['limit'] = '5';

    if (!address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }

    uri = uri.replace(queryParameters: _queryParams);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> searchFoods(String search, Address address) async {
  try {
    Uri uri =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}foods');
    Map<String, dynamic> _queryParams = {};
    // _queryParams['search'] = 'name:$search;description:$search';
    // _queryParams['searchFields'] = 'name:like;descrip
    _queryParams['search_value'] = '$search';
    _queryParams['limit'] = '5';
    if (!address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }

    uri = uri.replace(queryParameters: _queryParams);
    print(uri);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFoodsByCuisine(cuisineId) async {
  try {
    Uri uri =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}foods');
    Map<String, dynamic> _queryParams = {};
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    _queryParams['cuisines[]'] = '=$cuisineId';

    // _queryParams = filter.toQuery(oldQuery: _queryParams);
    uri = uri.replace(queryParameters: _queryParams);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFoodsByCategory(categoryId) async {
  try {
    Uri uri =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}foods');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    _queryParams['with'] = 'restaurant';
    _queryParams['search'] = 'category_id:$categoryId';
    _queryParams['searchFields'] = 'category_id:=';

    _queryParams = filter.toQuery(oldQuery: _queryParams);
    uri = uri.replace(queryParameters: _queryParams);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Favorite>> isFavoriteFood(String foodId) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().get('api_base_url')}favorites/exist?${_apiToken}food_id=$foodId&user_id=${_user.id}';
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getObjectData(data))
          .map((data) => Favorite.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Stream<Favorite>> getFavorites() async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().get('api_base_url')}favorites?${_apiToken}with=food;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

    print(url);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) => Favorite.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Favorite> addFavorite(Favorite favorite) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Favorite();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    favorite.userId = _user.id;
    final String url =
        '${GlobalConfiguration().get('api_base_url')}favorites?$_apiToken';
    final client = new http.Client();
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(favorite.toMap()),
    );
    if (response.statusCode == 200)
      return Favorite.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return Favorite.fromJSON({});
  }
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Favorite();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().get('api_base_url')}favorites/${favorite.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200)
      return Favorite.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return Favorite.fromJSON({});
  }
}

Future<Stream<Food>> getFoodsOfRestaurant(String restaurantId,
    {List<String> categories}) async {
  try {
    Uri uri = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}foods/categories');

    Map<String, dynamic> query = {
      'with': 'restaurant;category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId',
      'searchFields': 'restaurant_id:=',
    };

    if (categories != null && categories.isNotEmpty) {
      query['categories[]'] = categories;
    }

    uri = uri.replace(queryParameters: query);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        // print(Food.fromJSON(data).category_id);
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getTrendingFoodsOfRestaurant(String restaurantId) async {
  // TODO Trending foods only
  try {
    Uri uri =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}foods');
    uri = uri.replace(queryParameters: {
      'with': 'category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId;featured:1',
      'searchFields': 'restaurant_id:=;featured:=',
      'searchJoin': 'and',
    });

    print(uri);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Food.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) async {
  try {
    Uri uri =
        Uri.parse('${GlobalConfiguration().getValue('api_base_url')}foods');
    uri = uri.replace(queryParameters: {
      'with': 'category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId;featured:1',
      'searchFields': 'restaurant_id:=;featured:=',
      'searchJoin': 'and',
    });
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Food.fromJSON(data);
    });
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Review> addFoodReview(Review review, Food food) async {
  try {
    final String url =
        '${GlobalConfiguration().get('api_base_url')}food_reviews';
    final client = new http.Client();
    review.user = userRepo.currentUser.value;
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofFoodToMap(food)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return Review.fromJSON({});
  }
}
