import 'package:country_code_picker/country_code.dart';
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

class SignInScreen extends StatefulWidget {
  final String pageString;
  SignInScreen({
    this.pageString,
  });

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();
    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                Get.find<SplashController>().configModel.country,
              ).dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
    _passwordController.text =
        Get.find<AuthController>().getUserPassword() ?? '';
  }

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
                      ? EdgeInsets.all(
                          Dimensions.PADDING_SIZE_DEFAULT,
                        )
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
                        SizedBox(
                            height: Dimensions.PADDING_SIZE_OVER_LARGE + 4),

                        Text(
                          'sign_in'.tr,
                          style: robotoBold.copyWith(fontSize: 24),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE + 12),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.RADIUS_SMALL,
                            ),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Colors.grey[Get.isDarkMode ? 800 : 200],
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: 'email'.tr,
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Images.mail,
                                divider: false,
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
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.visiblePassword,
                                prefixIcon: Images.lock,
                                isPassword: true,
                                onSubmit: (text) => (GetPlatform.isWeb &&
                                        authController.acceptTerms)
                                    ? _login(authController, _countryDialCode)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                onTap: () => authController.toggleRememberMe(),
                                leading: Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: authController.isActiveRememberMe,
                                  onChanged: (bool isChecked) =>
                                      authController.toggleRememberMe(),
                                ),
                                title: Text('remember_me'.tr),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                horizontalTitleGap: 0,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed(
                                  RouteHelper.getForgotPassRoute(false, null)),
                              child: Text('${'forgot_password'.tr}?'),
                            ),
                          ],
                        ),

                        ConditionCheckBox(
                          authController: authController,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        !authController.isLoading
                            ? Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                child: CustomButton(
                                  buttonText: 'sign_in'.tr,
                                  height: 44,
                                  radius: 30,
                                  onPressed: authController.acceptTerms
                                      ? () => _login(
                                            authController,
                                            _countryDialCode,
                                          )
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
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
                            Get.toNamed(
                              RouteHelper.getGuestSignin(),
                            );
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        Row(
                          children: [
                            Spacer(),
                            Text('have_not_account'.tr, style: robotoRegular),
                            InkWell(
                              onTap: () {
                                Get.offAndToNamed(
                                  RouteHelper.getSignUpRoute(),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                child: Text(
                                  'sign_up'.tr,
                                  style: robotoMedium.copyWith(
                                      color: Colors.blue, fontSize: 16),
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

  void _login(AuthController authController, String countryDialCode) async {
    String _email = _phoneController.text.trim();
    String _password = _passwordController.text.trim();

    if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.login(_email, _password).then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserEmailAndPassword(_email, _password);
          } else {
            authController.clearUserEmailAndPassword();
          }
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
