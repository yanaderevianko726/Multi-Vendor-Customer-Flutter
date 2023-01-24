import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';

class SplashScreen extends StatefulWidget {
  final String orderID;
  SplashScreen({
    @required this.orderID,
  });
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (!_firstTime) {
          bool isNotConnected = result != ConnectivityResult.wifi &&
              result != ConnectivityResult.mobile;
          isNotConnected
              ? SizedBox()
              : ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: isNotConnected ? Colors.red : Colors.green,
              duration: Duration(seconds: isNotConnected ? 6000 : 3),
              content: Text(
                isNotConnected ? 'no_connection'.tr : 'connected'.tr,
                textAlign: TextAlign.center,
              ),
            ),
          );
          if (!isNotConnected) {
            _route();
          }
        }
        _firstTime = false;
      },
    );

    Get.find<SplashController>().initSharedData();
    Get.find<CartController>().getCartData();
    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  Future<void> _route() async {
    var deviceId = await PlatformDeviceId.getDeviceId;
    Get.find<AuthController>().setDeviceId(deviceId);

    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          if (widget.orderID != null) {
            Get.offAndToNamed(
              RouteHelper.getOrderDetailsRoute(
                int.parse(widget.orderID),
              ),
            );
          } else {
            if (Get.find<AuthController>().isLoggedIn()) {
              Get.find<AuthController>().updateToken();
              await Get.find<UserController>().getUserInfo().then(
                (value) async {
                  await Get.find<WishListController>().getWishList();
                  if (Get.find<LocationController>().getUserAddress() != null) {
                    Get.offAndToNamed(RouteHelper.getInitialRoute());
                  } else {
                    Get.offAndToNamed(
                      RouteHelper.getAccessLocationRoute('splash'),
                    );
                  }
                },
              );
            } else {
              if (Get.find<SplashController>().showIntro()) {
                Get.offAndToNamed(
                  RouteHelper.getOnBoardingRoute(),
                );
              } else {
                Get.offAndToNamed(
                  RouteHelper.getSignInRootRoute(),
                );
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Color(0xFFF26C61),
      body: GetBuilder<SplashController>(
        builder: (splashController) {
          return splashController.hasConnection
              ? Center(
                  child: Image.asset(
                    'assets/image/splash_logo.png',
                    width: context.width * 0.7,
                    fit: BoxFit.fitWidth,
                  ),
                )
              : Center(
                  child: NoInternetScreen(
                    child: SplashScreen(orderID: widget.orderID),
                  ),
                );
        },
      ),
    );
  }
}
