import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPassScreen extends StatefulWidget {
  final String resetToken;
  final String number;
  final bool fromPasswordChange;
  NewPassScreen({
    @required this.resetToken,
    @required this.number,
    @required this.fromPasswordChange,
  });

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  Future<void> initPageData() async {
    _newPasswordController.text = '';
    _oldPasswordController.text = '';
    _confirmPasswordController.text = '';
  }

  @override
  void initState() {
    super.initState();
    initPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.fromPasswordChange
            ? 'change_password'.tr
            : 'reset_password'.tr,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(
          Dimensions.PADDING_SIZE_SMALL,
        ),
        child: Container(
          width: context.width > 700 ? 700 : context.width,
          height: context.height - 112,
          padding: EdgeInsets.all(
            Dimensions.PADDING_SIZE_DEFAULT,
          ),
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
          child: Column(children: [
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Text(
              'enter_new_password'.tr,
              style: robotoRegular,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_OVER_LARGE),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  Dimensions.RADIUS_SMALL,
                ),
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
                  hintText: 'current_password'.tr,
                  controller: _oldPasswordController,
                  focusNode: _oldPasswordFocus,
                  nextFocus: _newPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Images.lock,
                  isPassword: true,
                  divider: true,
                ),
                CustomTextField(
                  hintText: 'new_password'.tr,
                  controller: _newPasswordController,
                  focusNode: _newPasswordFocus,
                  nextFocus: _confirmPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Images.lock,
                  isPassword: true,
                  divider: true,
                ),
                CustomTextField(
                  hintText: 'confirm_password'.tr,
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Images.lock,
                  isPassword: true,
                  onSubmit: (text) =>
                      GetPlatform.isWeb ? _resetPassword() : null,
                ),
              ]),
            ),
            Expanded(
              child: SizedBox(height: 30),
            ),
            GetBuilder<UserController>(builder: (userController) {
              return GetBuilder<AuthController>(builder: (authBuilder) {
                return (!authBuilder.isLoading && !userController.isLoading)
                    ? CustomButton(
                        buttonText: 'save'.tr,
                        radius: 12,
                        onPressed: () => _resetPassword(),
                      )
                    : Center(child: CircularProgressIndicator());
              });
            }),
          ]),
        ),
      ),
    );
  }

  void _resetPassword() {
    String _oldPassword = _oldPasswordController.text.trim();
    String _password = _newPasswordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    if (_oldPassword.isEmpty) {
      showCustomSnackBar('enter_current_password'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      if (widget.fromPasswordChange) {
        var currentPassword = Get.find<AuthController>().getUserPassword();
        if (_oldPassword == currentPassword) {
          UserInfoModel _user = Get.find<UserController>().userInfoModel;
          _user.password = _password;
          Get.find<UserController>().changePassword(_user).then((response) {
            if (response.isSuccess) {
              showCustomSnackBar('password_updated_successfully'.tr,
                  isError: false);
            } else {
              showCustomSnackBar(response.message);
            }
          });
        } else {
          showCustomSnackBar('enter_current_password'.tr);
        }
      } else {
        Get.find<AuthController>()
            .resetPassword(widget.resetToken, '+' + widget.number.trim(),
                _password, _confirmPassword)
            .then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>()
                .login('+' + widget.number.trim(), _password)
                .then((value) async {
              Get.offAllNamed(
                  RouteHelper.getAccessLocationRoute('reset-password'));
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}
