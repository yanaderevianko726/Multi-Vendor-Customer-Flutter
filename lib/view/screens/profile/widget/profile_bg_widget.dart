import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/user_controller.dart';
import '../../../../helper/route_helper.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget circularImage;
  final Widget mainWidget;
  final bool backButton;
  ProfileBgWidget({
    @required this.mainWidget,
    @required this.circularImage,
    @required this.backButton,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 84,
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 800 : 200],
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              children: [
                backButton
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                        ),
                        onPressed: () => Get.back(),
                      )
                    : SizedBox(),
                Spacer(),
                Text(
                  'account_title'.tr,
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                Spacer(),
                backButton
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: InkWell(
                          onTap: () => Get.toNamed(
                            RouteHelper.getCartRoute(),
                          ),
                          child: Badge(
                            label: Text(
                              '${cartController.cartList != null && cartController.cartList.isNotEmpty ? cartController.cartList.length : 0}',
                              style: robotoRegular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            child: Image.asset(
                              'assets/image/ic_cart.png',
                              width: 22,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 128,
            margin: EdgeInsets.only(
              left: Dimensions.PADDING_SIZE_SMALL,
              right: Dimensions.PADDING_SIZE_SMALL,
              top: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_SMALL,
              vertical: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 800 : 200],
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              children: [
                circularImage,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetBuilder<UserController>(builder: (userController) {
                          var fullName = 'guest'.tr;
                          if (userController.userInfoModel != null)
                            fullName =
                                '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}';
                          return Container(
                            child: Text(
                              fullName,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          );
                        }),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_SMALL * 0.8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/image/ic_award.png',
                              width: 18,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(
                              width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            ),
                            Text(
                              'Premium Member',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_SMALL * 0.8,
                        ),
                        Text(
                          '1236 Points',
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: mainWidget,
          ),
        ],
      );
    });
  }
}
