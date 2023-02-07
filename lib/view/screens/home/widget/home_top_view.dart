import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTopView extends StatelessWidget {
  final Function openDrawer;
  const HomeTopView({Key key, this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddingTop = 32;
    double mainPadding = 6;
    return GetBuilder<CartController>(builder: (cartController) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: paddingTop + 60,
        padding: EdgeInsets.only(
          top: paddingTop + 2,
          left: mainPadding + 2,
          right: mainPadding * 2,
          bottom: mainPadding,
        ),
        color: Theme.of(context).cardColor,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                openDrawer();
              },
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.menu,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 14,
                  top: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'delivering_to'.tr,
                      style: TextStyle(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              RouteHelper.getAccessLocationRoute(
                                RouteHelper.home,
                              ),
                            );
                          },
                          child: GetBuilder<LocationController>(
                              builder: (locationController) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    locationController.getUserAddress().address,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeSmall,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    RouteHelper.getCartRoute(),
                  );
                },
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
            ),
            SizedBox(
              width: 6,
            ),
          ],
        ),
      );
    });
  }
}
