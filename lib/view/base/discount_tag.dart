import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTag extends StatelessWidget {
  final double discount;
  final String discountType;
  final double fontSize;
  final double height;
  final Color bckColor;
  final int type;
  final int style;

  DiscountTag({
    @required this.discount,
    @required this.discountType,
    this.fontSize = 12,
    this.height = 34,
    this.bckColor,
    this.type = 0, // 0: discount, 1: free delivery, 2: trending, 3: new
    this.style = 0,
  });

  @override
  Widget build(BuildContext context) {
    return bodyWidget(context);
  }

  Widget bodyWidget(BuildContext context) {
    print('=== style: $style');
    if (type == 0) {
      return discount > 0
          ? Container(
              height: height,
              margin: EdgeInsets.only(left: 8, top: 8),
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: bckColor != null ? bckColor : Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.RADIUS_SMALL),
                ),
              ),
              child: Row(
                children: [
                  bckColor != null
                      ? Image.asset(
                          'assets/image/ic_discount_white.png',
                          width: 15,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.asset(
                          'assets/image/ic_discount.png',
                          width: 15,
                          fit: BoxFit.fitWidth,
                        ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel.currencySymbol} ${'off'.tr}',
                    style: robotoMedium.copyWith(
                      color:
                          bckColor != null ? Colors.white : Colors.blueAccent,
                      fontSize: fontSize,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Container();
    } else if (type == 1) {
      return Container(
        height: height,
        margin: EdgeInsets.only(left: 8, top: 10),
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: bckColor != null ? bckColor : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.sell_outlined,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'free_delivery'.tr,
              style: robotoMedium.copyWith(
                color: bckColor != null
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                fontSize: fontSize,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (type == 2) {
      return style == 0
          ? Container(
              height: height,
              margin: EdgeInsets.only(left: 10, top: 8),
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 2),
              decoration: BoxDecoration(
                color: bckColor != null ? bckColor : orangeLight,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'trending'.tr,
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Container(
              width: 90,
              margin: EdgeInsets.only(left: 1.2, top: 10),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/image/ic_trending_label.png',
                    width: 92,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7, left: 10),
                    child: Text(
                      '${'trending'.tr}  ',
                      style: robotoMedium.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
    } else if (type == 3) {
      return style == 0
          ? Container(
              height: height,
              margin: EdgeInsets.only(left: 8, top: 10),
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 2),
              decoration: BoxDecoration(
                color: bckColor != null ? bckColor : blueDeep,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  '${'new'.tr}',
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Container(
              width: 64,
              margin: EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/image/ic_new_label.png',
                    width: 64,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      '${'new'.tr}  ',
                      style: robotoMedium.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
    }
    return Container();
  }
}
