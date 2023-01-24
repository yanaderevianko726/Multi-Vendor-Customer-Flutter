import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/data/model/response/language_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final int index;
  final LocalizationController localizationController;
  LanguageWidget({
    @required this.languageModel,
    @required this.localizationController,
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
      },
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[Get.isDarkMode ? 800 : 200],
                blurRadius: 5,
                spreadRadius: 1)
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: Dimensions.PADDING_SIZE_SMALL,
            ),
            Icon(
              localizationController.selectedIndex == index
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              color: localizationController.selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              size: 25,
            ),
            SizedBox(
              width: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            Text(languageModel.languageName, style: robotoRegular),
          ],
        ),
      ),
    );
  }
}
