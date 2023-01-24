import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null)
            ? Center(child: CircularProgressIndicator())
            : ProfileBgWidget(
                backButton: true,
                circularImage: Container(
                  color: Theme.of(context).cardColor,
                  alignment: Alignment.center,
                  child: ClipOval(
                      child: CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                        '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  )),
                ),
                mainWidget: Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  padding: EdgeInsets.all(
                    Dimensions.PADDING_SIZE_SMALL,
                  ),
                  child: Column(children: [
                    SizedBox(
                      height: Dimensions.PADDING_SIZE_DEFAULT,
                    ),
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
                              'assets/image/ic_user_red.png',
                              width: 18,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        title: 'profile'.tr,
                        onTap: () {
                          Get.toNamed(RouteHelper.getUpdateProfileRoute());
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
                              'assets/image/ic_wallet.png',
                              width: 18,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        title: '${'payment'.tr} ${'details'.tr}',
                        onTap: () {
                          Get.toNamed(RouteHelper.getPaymentDetails());
                        }),
                    SizedBox(
                        height:
                            _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
                    _isLoggedIn
                        ? ProfileButton(
                            iconWidget: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.4),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/image/ic_location_red.png',
                                  width: 18,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            title: 'my_address'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getAddressInfoRoute());
                            })
                        : SizedBox(),
                    SizedBox(
                      height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0,
                    ),
                    _isLoggedIn &&
                            Get.find<UserController>().userInfoModel != null &&
                            Get.find<UserController>().userInfoModel.isGuest ==
                                0
                        ? ProfileButton(
                            iconWidget: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.4),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/image/ic_locl_red.png',
                                  width: 18,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            title: 'change_password'.tr,
                            onTap: () {
                              Get.toNamed(
                                RouteHelper.getResetPasswordRoute(
                                  '',
                                  '',
                                  'password-change',
                                ),
                              );
                            })
                        : SizedBox(),
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
                              'assets/image/ic_settings.png',
                              width: 18,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        title: 'settings'.tr,
                        onTap: () {
                          Get.toNamed(RouteHelper.getSettingsRoute());
                        }),
                    SizedBox(
                        height: _isLoggedIn
                            ? Dimensions.PADDING_SIZE_SMALL
                            : Dimensions.PADDING_SIZE_LARGE),
                    // _isLoggedIn
                    //     ? ProfileButton(
                    //         icon: Icons.delete,
                    //         title: 'delete_account'.tr,
                    //         onTap: () {
                    //           Get.dialog(
                    //               ConfirmationDialog(
                    //                 icon: Images.support,
                    //                 title:
                    //                     'are_you_sure_to_delete_account'.tr,
                    //                 description:
                    //                     'it_will_remove_your_all_information'
                    //                         .tr,
                    //                 isLogOut: true,
                    //                 onYesPressed: () =>
                    //                     userController.removeUser(),
                    //               ),
                    //               useSafeArea: false);
                    //         },
                    //       )
                    //     : SizedBox(),
                    // SizedBox(
                    //     height: _isLoggedIn
                    //         ? Dimensions.PADDING_SIZE_LARGE
                    //         : 0),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text('${'version'.tr}:',
                    //           style: robotoRegular.copyWith(
                    //               fontSize: Dimensions.fontSizeExtraSmall)),
                    //       SizedBox(
                    //           width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    //       Text(AppConstants.APP_VERSION.toString(),
                    //           style: robotoMedium.copyWith(
                    //               fontSize: Dimensions.fontSizeExtraSmall)),
                    //     ]),
                  ]),
                ),
              );
      }),
    );
  }
}
