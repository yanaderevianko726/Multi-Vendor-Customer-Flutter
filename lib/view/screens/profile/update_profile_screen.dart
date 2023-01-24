import 'dart:io';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoggedIn;

  void initPage() {
    Get.find<UserController>().initData();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<UserController>(builder: (userController) {
        if (userController.userInfoModel != null &&
            _phoneController.text.isEmpty) {
          _firstNameController.text = userController.userInfoModel.fName ?? '';
          _lastNameController.text = userController.userInfoModel.lName ?? '';
          _phoneController.text = userController.userInfoModel.phone ?? '';
          _emailController.text = userController.userInfoModel.email ?? '';
        }

        return _isLoggedIn
            ? userController.userInfoModel != null
                ? SingleChildScrollView(
                    child: Column(
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
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  margin: EdgeInsets.only(left: 12),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                'profile'.tr,
                                textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 46,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: ClipOval(
                                      child: userController.pickedFile != null
                                          ? GetPlatform.isWeb
                                              ? Image.network(
                                                  userController
                                                      .pickedFile.path,
                                                  height: 92,
                                                  width: 92,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(userController
                                                      .pickedFile.path),
                                                  height: 92,
                                                  width: 92,
                                                  fit: BoxFit.cover,
                                                )
                                          : CustomImage(
                                              image:
                                                  '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${userController.userInfoModel.image}',
                                              height: 92,
                                              width: 92,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => userController.pickImage(),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 64),
                                        color: Colors.black.withOpacity(0.3),
                                        child: Center(
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 24,
                          margin: EdgeInsets.only(top: 8),
                          child: Center(
                            child: Text(
                              '${_firstNameController.text} ${_lastNameController.text}',
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            Dimensions.PADDING_SIZE_LARGE,
                          ),
                          width: Dimensions.WEB_MAX_WIDTH,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'first_name'.tr,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.3),
                                    child: MyTextField(
                                      hintText: 'first_name'.tr,
                                      controller: _firstNameController,
                                      focusNode: _firstNameFocus,
                                      nextFocus: _lastNameFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                Text(
                                  'last_name'.tr,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.3),
                                    child: MyTextField(
                                      hintText: 'last_name'.tr,
                                      controller: _lastNameController,
                                      focusNode: _lastNameFocus,
                                      nextFocus: _emailFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Get.find<UserController>().userInfoModel !=
                                            null &&
                                        Get.find<UserController>()
                                                .userInfoModel
                                                .isGuest ==
                                            0
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          Text(
                                            'email'.tr,
                                            style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.3),
                                              child: MyTextField(
                                                hintText: 'email'.tr,
                                                controller: _emailController,
                                                focusNode: _emailFocus,
                                                inputAction:
                                                    TextInputAction.done,
                                                inputType:
                                                    TextInputType.emailAddress,
                                                fillColor: Colors.transparent,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL,
                                ),
                                Row(children: [
                                  Text(
                                    '${'Phone Number'.tr}',
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                ]),
                                SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    color: Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.3),
                                    child: MyTextField(
                                      hintText: 'phone'.tr,
                                      controller: _phoneController,
                                      focusNode: _phoneFocus,
                                      inputType: TextInputType.phone,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                        ),
                        !userController.isLoading
                            ? InkWell(
                                onTap: () => _updateProfile(userController),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 46,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_LARGE,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'update'.tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraLarge,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator())
            : NotLoggedInScreen();
      }),
    );
  }

  void _updateProfile(UserController userController) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    if (userController.userInfoModel.fName == _firstName &&
        userController.userInfoModel.lName == _lastName &&
        userController.userInfoModel.phone == _phoneNumber &&
        userController.userInfoModel.email == _emailController.text &&
        userController.pickedFile == null) {
      showCustomSnackBar('Change something to update'.tr);
    } else if (_firstName.isEmpty) {
      showCustomSnackBar('Enter your first name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('Enter your last name'.tr);
    } else if (_email.isEmpty &&
        Get.find<UserController>().userInfoModel != null &&
        Get.find<UserController>().userInfoModel.isGuest == 0) {
      showCustomSnackBar('Enter email address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('Enter a valid email address'.tr);
    } else if (_phoneNumber.isEmpty) {
      showCustomSnackBar('Enter a phone number'.tr);
    } else if (_phoneNumber.length < 6) {
      showCustomSnackBar('Enter a valid phone number'.tr);
    } else {
      UserInfoModel _updatedUser = UserInfoModel(
        fName: _firstName,
        lName: _lastName,
        email: _email,
        phone: _phoneNumber,
      );
      ResponseModel _responseModel = await userController.updateUserInfo(
          _updatedUser, Get.find<AuthController>().getUserToken());
      if (_responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      } else {
        showCustomSnackBar(_responseModel.message);
      }
    }
  }
}
