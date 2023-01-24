import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('accessLocation: getAccessLocationRoute');
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(1, 40),
      ),
      onPressed: () {
        // Navigator.pushReplacementNamed(
        //   context,
        //   RouteHelper.getInitialRoute(),
        // );
        Get.toNamed(
          RouteHelper.getAccessLocationRoute(
            RouteHelper.initial,
          ),
        );
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${'continue_as'.tr} ',
            style:
                robotoRegular.copyWith(color: Theme.of(context).disabledColor),
          ),
          TextSpan(
            text: 'guest'.tr,
            style: robotoMedium.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeLarge,
            ),
          ),
        ]),
      ),
    );
  }
}
