import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/theme_controller.dart';
import '../../helper/route_helper.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import '../screens/profile/widget/profile_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
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
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                  ),
                  onPressed: () => Get.back(),
                ),
                Spacer(),
                Text(
                  'settings'.tr,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                ProfileButton(
                    iconWidget: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.dark_mode,
                          size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    title: 'dark_mode'.tr,
                    isButtonActive: Get.isDarkMode,
                    onTap: () {
                      Get.find<ThemeController>().toggleTheme();
                    }),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                GetBuilder<AuthController>(
                  builder: (authController) {
                    return ProfileButton(
                      iconWidget: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.4),
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.notifications,
                            size: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      title: 'notification'.tr,
                      isButtonActive: authController.notification,
                      onTap: () {
                        authController.setNotificationActive(
                            !authController.notification);
                      },
                    );
                  },
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                ProfileButton(
                    iconWidget: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/image/ic_language.png',
                          width: 18,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    title: 'language_settings'.tr,
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.getLanguageRoute('menu'),
                      );
                    }),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                ProfileButton(
                    iconWidget: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/image/ic_global.png',
                          width: 18,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    title: 'country_settings'.tr,
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.getCountryRoute('menu'),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
