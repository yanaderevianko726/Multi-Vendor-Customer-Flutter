import 'dart:async';
import 'dart:io';

import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInRootScreen extends StatefulWidget {
  const SignInRootScreen({Key key}) : super(key: key);
  @override
  State<SignInRootScreen> createState() => _SignInRootScreenState();
}

class _SignInRootScreenState extends State<SignInRootScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_canExit) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          } else {
            Navigator.pushNamed(context, RouteHelper.getInitialRoute());
          }
          return Future.value(false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(
                Dimensions.PADDING_SIZE_SMALL,
              ),
            ),
          );
          _canExit = true;
          Timer(Duration(seconds: 2), () {
            _canExit = false;
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/image/img_login_logo.png',
                width: context.width,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: Dimensions.PADDING_SIZE_DEFAULT,
              ),
              Text(
                'the_best_title'.tr,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.height * 0.025),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_OVER_LARGE,
                ),
                child: Text(
                  'login_description'.tr,
                  style: robotoRegular.copyWith(
                    fontSize: context.height * 0.018,
                    color: Theme.of(context).disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_OVER_LARGE),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_OVER_LARGE,
                ),
                child: CustomButton(
                  buttonText: 'login_title'.tr,
                  height: 44,
                  radius: 30,
                  onPressed: () => Get.toNamed(
                    RouteHelper.getSignInRoute(RouteHelper.signInRoot),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              InkWell(
                child: Container(
                  width: context.width,
                  height: 44,
                  margin: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_OVER_LARGE,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                        width: 1, color: Theme.of(context).primaryColor),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'create_account'.tr,
                      textAlign: TextAlign.center,
                      style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),
                ),
                onTap: () => Get.toNamed(
                  RouteHelper.getSignUpRoute(),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            ],
          ),
        ),
      ),
    );
  }
}
