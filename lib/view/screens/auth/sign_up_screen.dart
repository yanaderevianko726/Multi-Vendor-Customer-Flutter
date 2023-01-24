import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/auth/widget/condition_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? WebMenuBar()
          : AppBar(
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT,
                bottom: Dimensions.PADDING_SIZE_DEFAULT,
                right: Dimensions.PADDING_SIZE_DEFAULT,
              ),
              child: Center(
                child: Container(
                  width: context.width > 700 ? 700 : context.width,
                  padding: context.width > 700
                      ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                      : null,
                  decoration: context.width > 700
                      ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.RADIUS_SMALL,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300],
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                        )
                      : null,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Column(
                      children: [
                        Image.asset(
                          'assets/image/logo_without_title.png',
                          width: 60,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          'SWUSHD',
                          style: robotoMedium.copyWith(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          'Kitchens',
                          style: robotoRegular.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Text(
                          'sign_up'.tr,
                          style: robotoBold.copyWith(fontSize: 24),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE + 4),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 800 : 200],
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: Column(children: [
                            CustomTextField(
                              hintText: 'first_name'.tr,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus: _lastNameFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              prefixIcon: 'assets/image/ic_user.png',
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Divider(height: 1),
                            ),
                            CustomTextField(
                              hintText: 'last_name'.tr,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              prefixIcon: 'assets/image/ic_user.png',
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Divider(height: 1),
                            ),
                            CustomTextField(
                              hintText: 'email'.tr,
                              controller: _emailController,
                              focusNode: _emailFocus,
                              nextFocus: _passwordFocus,
                              inputType: TextInputType.emailAddress,
                              prefixIcon: Images.mail,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Divider(height: 1),
                            ),
                            CustomTextField(
                              hintText: 'password'.tr,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              inputType: TextInputType.visiblePassword,
                              prefixIcon: Images.lock,
                              isPassword: true,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Divider(height: 1),
                            ),
                            CustomTextField(
                              hintText: 'confirm_password'.tr,
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              nextFocus: Get.find<SplashController>()
                                          .configModel
                                          .refEarningStatus ==
                                      1
                                  ? _referCodeFocus
                                  : null,
                              inputAction: Get.find<SplashController>()
                                          .configModel
                                          .refEarningStatus ==
                                      1
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              inputType: TextInputType.visiblePassword,
                              prefixIcon: Images.lock,
                              isPassword: true,
                              onSubmit: (text) => (GetPlatform.isWeb &&
                                      authController.acceptTerms)
                                  ? _register()
                                  : null,
                            ),
                            (Get.find<SplashController>()
                                        .configModel
                                        .refEarningStatus ==
                                    1)
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.PADDING_SIZE_LARGE,
                                    ),
                                    child: Divider(height: 1),
                                  )
                                : SizedBox(),
                            (Get.find<SplashController>()
                                        .configModel
                                        .refEarningStatus ==
                                    1)
                                ? CustomTextField(
                                    hintText: 'refer_code'.tr,
                                    controller: _referCodeController,
                                    focusNode: _referCodeFocus,
                                    inputAction: TextInputAction.done,
                                    inputType: TextInputType.text,
                                    capitalization: TextCapitalization.words,
                                    prefixIcon: Images.refer_code,
                                    prefixSize: 14,
                                  )
                                : SizedBox(),
                          ]),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        ConditionCheckBox(authController: authController),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                        !authController.isLoading
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                child: CustomButton(
                                  buttonText: 'sign_up'.tr,
                                  height: 44,
                                  radius: 30,
                                  onPressed: authController.acceptTerms
                                      ? () => _register()
                                      : null,
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        InkWell(
                          child: Container(
                            width: context.width,
                            height: 44,
                            margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                '${'continue_as'.tr} ${'guest'.tr}',
                                textAlign: TextAlign.center,
                                style: robotoBold.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeLarge,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            // Navigator.pushReplacementNamed(
                            //   context,
                            //   RouteHelper.getInitialRoute(),
                            // );
                            Get.toNamed(
                              RouteHelper.getGuestSignin(),
                            );
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        Row(
                          children: [
                            Spacer(),
                            Text('have_account'.tr, style: robotoRegular),
                            InkWell(
                              onTap: () {
                                Get.offAndToNamed(RouteHelper.getSignInRoute(
                                  RouteHelper.signUp,
                                ));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                child: Text(
                                  'sign_in'.tr,
                                  style: robotoMedium.copyWith(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 30),

                        // SocialLoginWidget(),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _referCode = _referCodeController.text.trim();

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 8) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else if (_referCode.isNotEmpty && _referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    } else {
      Get.toNamed(
        RouteHelper.getEntryPhoneRoute(
            _firstName, _lastName, _email, _password, _referCode),
      );
    }
  }
}
