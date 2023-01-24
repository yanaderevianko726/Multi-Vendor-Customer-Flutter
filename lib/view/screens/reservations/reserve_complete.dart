import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReserveCompleteScreen extends StatefulWidget {
  const ReserveCompleteScreen({
    Key key,
  }) : super(key: key);
  @override
  State<ReserveCompleteScreen> createState() => _ReserveCompleteScreenState();
}

class _ReserveCompleteScreenState extends State<ReserveCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    double bigR = 64;
    double medR = 34;
    double smR = 30;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: GetBuilder<CartController>(builder: (cartController) {
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).viewPadding.top + 60,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top,
                  ),
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
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Reserve A Table'.tr,
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: InkWell(
                          onTap: () => Get.toNamed(
                            RouteHelper.getCartRoute(),
                          ),
                          child: Badge(
                            badgeContent: Text(
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
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: bigR * 2,
                  height: bigR * 2,
                  decoration: BoxDecoration(
                    color: blueDeep,
                    borderRadius: BorderRadius.all(
                      Radius.circular(bigR),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: medR * 2,
                      height: medR * 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(medR),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: smR * 2,
                          height: smR * 2,
                          decoration: BoxDecoration(
                            color: blueDeep,
                            borderRadius: BorderRadius.all(
                              Radius.circular(smR),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: smR * 0.7,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 36,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Congratulations!',
                    style: robotoBold.copyWith(
                      fontSize: 22,
                      color: blueDeep,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Your seating reservation has been successfully placed. Please check it from the list.',
                    style: robotoRegular.copyWith(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    margin: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Back to Main'.tr,
                        style: robotoBold.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
