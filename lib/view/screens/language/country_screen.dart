import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/language/widget/country_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryScreen extends StatelessWidget {
  final bool fromMenu;
  CountryScreen({this.fromMenu = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (fromMenu || ResponsiveHelper.isDesktop(context))
          ? CustomAppBar(title: 'country_settings'.tr, isBackButtonExist: true)
          : null,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(
            builder: (localizationController) {
          return Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  Dimensions.PADDING_SIZE_SMALL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Dimensions.PADDING_SIZE_EXTRA_SMALL + 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        key: UniqueKey(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: localizationController.languages.length,
                        itemBuilder: (context, index) {
                          return CountryWidget(
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
                  localizationController.setLanguage(Locale(
                    AppConstants.languages[localizationController.selectedIndex]
                        .languageCode,
                    AppConstants.languages[localizationController.selectedIndex]
                        .countryCode,
                  ));
                  if (fromMenu) {
                    Navigator.pop(context);
                  } else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                } else {
                  showCustomSnackBar('select_a_language'.tr);
                }
              },
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          ]);
        }),
      ),
    );
  }
}
