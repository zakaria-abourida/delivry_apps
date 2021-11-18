import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../controllers/loading_screen_controller.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoadingScreenState();
  }
}

class LoadingScreenState extends StateMVC<LoadingScreen> {
  LoadingScreenController _con;

  LoadingScreenState() : super(LoadingScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    //settingRepo.initSettings();
    //settingRepo.setCurrentLocation();
    Future.delayed(Duration(milliseconds: 200)).whenComplete(() => loadData());
  }

  Future<void> loadData() async {
    await GlobalConfiguration().loadFromAsset("configurations");
    await settingRepo.initSettings();
    settingRepo.setCurrentLocation();
    userRepo.getCurrentUser().then((value) {
      if (value.apiToken != null)
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
      else
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Geolocation', (Route<dynamic> route) => false);
    });

    /* double progress = 0;
    _con.progress.addListener(() {
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
        print('--------------------$progress');
      });
      if (progress > 50) {
        try {
          if (userRepo.currentUser.value.apiToken != null)
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Home', (Route<dynamic> route) => false);
          else
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Geolocation', (Route<dynamic> route) => false);
        } catch (e) {
          print(e);
        }
      }
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: SpinKitRipple(
                    color: Constants.primaryColor,
                    size: 400.sp,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/img/icon-scren-1.png",
                      ),
                    ),
                  ),
                  height: 500.h,
                  width: MediaQuery.of(context).size.width,
                ),
              )
            ],
          ),
          Container(
            child: Image.asset(
              'assets/img/logo.png',
              fit: BoxFit.fitHeight,
              height: 150.h,
            ),
          ),
          Container(
            height: 20.h,
            child: SpinKitChasingDots(
              color: Constants.primaryColor,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
