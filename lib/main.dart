import 'dart:async';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';

import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/restaurant_repository.dart' as restoRepo;

import 'src/store/refresh_model.dart';

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  //FIREBASE SETUP
  await Firebase.initializeApp();

  runZonedGuarded(() {
    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initializeFlutterFireFuture;

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

    //FACEBOOK SETUP
    final facebookAppEvents = FacebookAppEvents();
    facebookAppEvents.setAdvertiserTracking(enabled: true);
    facebookAppEvents.logEvent(name: FacebookAppEvents.eventNameActivatedApp);
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFire();
    initializeFlutterFireFuture = _initializeFlutterFire();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('Ayoub-------------------------------------------');
        //TODO:: ADD RESTAURANT ID PARAMETER
        final resto = await restoRepo.getRestaurant("restaurantID");
        if (resto != null) {
          settingRepo.navigatorKey.currentState.pushReplacementNamed(
            '/Settings',
          );
        } else {
          //TODO:: REDIRECT TO NOT FOUND RESTAURANT PAGE
          settingRepo.navigatorKey.currentState.pushReplacementNamed(
            '/notFound',
          );
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(414.0, 896.0),
      builder: () => ScopedModel<RefreshModel>(
        model: RefreshModel(),
        child: ValueListenableBuilder(
          valueListenable: settingRepo.setting,
          builder: (context, Setting _setting, _) {
            return MaterialApp(
                //builder: DevicePreview.appBuilder,
                navigatorKey: settingRepo.navigatorKey,
                title: _setting.appName,
                initialRoute: '/Loading',
                onGenerateRoute: RouteGenerator.generateRoute,
                debugShowCheckedModeBanner: false,
                locale: _setting.mobileLanguage.value,
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: _setting.brightness.value == Brightness.light
                    ? ThemeData(
                        fontFamily: 'Poppins',
                        primaryColor: Colors.white,
                        floatingActionButtonTheme:
                            FloatingActionButtonThemeData(
                                elevation: 0, foregroundColor: Colors.white),
                        brightness: Brightness.light,
                        accentColor: config.Colors().mainColor(1),
                        dividerColor: config.Colors().accentColor(0.1),
                        focusColor: config.Colors().accentColor(1),
                        hintColor: config.Colors().secondColor(1),
                        textTheme: TextTheme(
                          headline5: TextStyle(
                              fontSize: 20.0,
                              color: config.Colors().secondColor(1),
                              height: 1.35),
                          headline4: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: config.Colors().secondColor(1),
                              height: 1.35),
                          headline3: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: config.Colors().secondColor(1),
                              height: 1.35),
                          headline2: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                              color: config.Colors().mainColor(1),
                              height: 1.35),
                          headline1: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300,
                              color: config.Colors().secondColor(1),
                              height: 1.5),
                          subtitle1: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: config.Colors().secondColor(1),
                              height: 1.35),
                          headline6: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: config.Colors().mainColor(1),
                              height: 1.35),
                          bodyText2: TextStyle(
                              fontSize: 12.0,
                              color: config.Colors().secondColor(1),
                              height: 1.35),
                          bodyText1: TextStyle(
                              fontSize: 14.0,
                              color: config.Colors().secondColor(1),
                              height: 1.35),
                          caption: TextStyle(
                              fontSize: 12.0,
                              color: config.Colors().accentColor(1),
                              height: 1.35),
                        ),
                      )
                    : ThemeData(
                        fontFamily: 'Poppins',
                        primaryColor: Color(0xFF252525),
                        brightness: Brightness.dark,
                        scaffoldBackgroundColor: Color(0xFF2C2C2C),
                        accentColor: config.Colors().mainDarkColor(1),
                        dividerColor: config.Colors().accentColor(0.1),
                        hintColor: config.Colors().secondDarkColor(1),
                        focusColor: config.Colors().accentDarkColor(1),
                        textTheme: TextTheme(
                          headline5: TextStyle(
                              fontSize: 20.0,
                              color: config.Colors().secondDarkColor(1),
                              height: 1.35),
                          headline4: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: config.Colors().secondDarkColor(1),
                              height: 1.35),
                          headline3: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: config.Colors().secondDarkColor(1),
                              height: 1.35),
                          headline2: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                              color: config.Colors().mainDarkColor(1),
                              height: 1.35),
                          headline1: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300,
                              color: config.Colors().secondDarkColor(1),
                              height: 1.5),
                          subtitle1: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: config.Colors().secondDarkColor(1),
                              height: 1.35),
                          headline6: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: config.Colors().mainDarkColor(1),
                              height: 1.35),
                          bodyText2: TextStyle(
                              fontSize: 12.0,
                              color: config.Colors().secondDarkColor(1),
                              height: 1.35),
                          bodyText1: TextStyle(
                              fontSize: 14.0,
                              color: config.Colors().secondDarkColor(1),
                              height: 1.35),
                          caption: TextStyle(
                              fontSize: 12.0,
                              color: config.Colors().secondDarkColor(0.6),
                              height: 1.35),
                        ),
                      ));
          },
        ),
      ),
    );
  }
}
