import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromMenu;
  ChooseLanguageScreen({this.fromMenu = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<LocalizationController>(
            builder: (localizationController) {
          return GetBuilder<CartController>(builder: (cartController) {
            return Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
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
                      'language_settings'.tr,
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
                      width: 16,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.PADDING_SIZE_SMALL,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: Dimensions.PADDING_SIZE_EXTRA_SMALL + 12,
                            left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text(
                          'select_language'.tr,
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          key: UniqueKey(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: localizationController.languages.length,
                          itemBuilder: (context, index) {
                            return LanguageWidget(
                              languageModel:
                                  localizationController.languages[index],
                              localizationController: localizationController,
                              index: index,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    ],
                  ),
                ),
              ),
              CustomButton(
                buttonText: 'save'.tr,
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                onPressed: () {
                  if (localizationController.languages.length > 0 &&
                      localizationController.selectedIndex != -1) {
                    localizationController.setLanguage(
                      Locale(
                        AppConstants
                            .languages[localizationController.selectedIndex]
                            .languageCode,
                        AppConstants
                            .languages[localizationController.selectedIndex]
                            .countryCode,
                      ),
                    );
                    if (fromMenu) {
                      Navigator.pop(context);
                    } else {
                      Get.offNamed(
                        RouteHelper.getOnBoardingRoute(),
                      );
                    }
                  } else {
                    showCustomSnackBar('select_a_language'.tr);
                  }
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
            ]);
          });
        }),
      ),
    );
  }
}
