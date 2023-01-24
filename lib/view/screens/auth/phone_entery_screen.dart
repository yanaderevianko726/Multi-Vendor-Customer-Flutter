import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class PhoneEntryScreen extends StatefulWidget {
  final String sFName;
  final String sLName;
  final String sEmail;
  final String sPass;
  final String sReferCode;
  const PhoneEntryScreen({
    Key key,
    this.sFName,
    this.sLName,
    this.sEmail,
    this.sPass,
    this.sReferCode,
  }) : super(key: key);
  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
      Get.find<SplashController>().configModel.country,
    ).dialCode;
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
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: Dimensions.PADDING_SIZE_DEFAULT,
              bottom: Dimensions.PADDING_SIZE_DEFAULT,
              right: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            child: Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700
                  ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                  : null,
              child: GetBuilder<AuthController>(builder: (authController) {
                return Column(
                  children: [
                    Text(
                      'continue_with_phone'.tr,
                      style: robotoMedium.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(
                      '${'you_will_receive'.tr}',
                      style: robotoRegular.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    Row(children: [
                      CodePickerWidget(
                        onChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        initialSelection: CountryCode.fromCountryCode(
                          Get.find<SplashController>().configModel.country,
                        ).code,
                        favorite: [
                          CountryCode.fromCountryCode(
                            Get.find<SplashController>().configModel.country,
                          ).code
                        ],
                        showDropDownButton: true,
                        padding: EdgeInsets.zero,
                        showFlagMain: true,
                        dialogBackgroundColor: Theme.of(context).cardColor,
                        textStyle: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'phone'.tr,
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          inputType: TextInputType.phone,
                          divider: false,
                        ),
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      child: CustomButton(
                        buttonText: 'verify'.tr,
                        height: 44,
                        radius: 30,
                        onPressed: authController.acceptTerms
                            ? () => _register(
                                  authController,
                                  _countryDialCode,
                                )
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.PADDING_SIZE_LARGE,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                      ),
                      child: Text(
                        'by_continuing'.tr,
                        style: robotoRegular.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String _number = _phoneController.text.trim();
    String _numberWithCountryCode = countryCode + _number;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }

    if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
        fName: widget.sFName,
        lName: widget.sLName,
        email: widget.sEmail,
        phone: '$_numberWithCountryCode',
        password: widget.sPass,
        refCode: widget.sReferCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(widget.sPass);
            String _data = base64Encode(_encoded);
            Get.toNamed(
              RouteHelper.getVerificationRoute(_numberWithCountryCode,
                  status.message, RouteHelper.phoneEntry, _data),
            );
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(
              RouteHelper.phoneEntry,
            ));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
