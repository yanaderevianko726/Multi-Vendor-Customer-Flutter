import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({Key key}) : super(key: key);
  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 22,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '${'payment'.tr} ${'details'.tr}',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 48,
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dimensions.PADDING_SIZE_SMALL,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.only(left: 18, top: 12),
            child: Text(
              'Customize your payment methods'.tr,
              style: robotoMedium.copyWith(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
            child: Text(
              'Add and choose your payment method'.tr,
              style: robotoRegular.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 14,
              right: 14,
              top: 18,
              bottom: 14,
            ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Cash/Card on delivery'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/image/ic_check.png',
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 1,
                      margin: EdgeInsets.only(top: 14, bottom: 24),
                      color: Theme.of(context).disabledColor.withOpacity(0.3),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/img_visa.png',
                          width: 56,
                          fit: BoxFit.fitWidth,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'xxxx  xxxx  xxxx',
                              style: robotoRegular.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.getCreditCardView());
                          },
                          child: Container(
                            width: 88,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(70),
                              ),
                              color: yellowLight,
                            ),
                            child: Center(
                              child: Text(
                                'Details'.tr,
                                style: robotoRegular.copyWith(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 1,
                      margin: EdgeInsets.only(top: 24, bottom: 14),
                      color: Theme.of(context).disabledColor.withOpacity(0.3),
                    ),
                    Row(
                      children: [
                        Text(
                          'Other Methods'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
