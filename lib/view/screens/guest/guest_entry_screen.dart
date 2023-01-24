import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GuestEntryScreen extends StatefulWidget {
  const GuestEntryScreen({Key key}) : super(key: key);
  @override
  State<GuestEntryScreen> createState() => _GuestEntryScreenState();
}

class _GuestEntryScreenState extends State<GuestEntryScreen> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  var isRegister = true;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = '';
      _emailController.text = '';
    });
    if (mounted) {
      _checkPermission(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    'assets/image/logo_without_title.png',
                    width: 60,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    height: Dimensions.PADDING_SIZE_SMALL,
                  ),
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
                    height: Dimensions.PADDING_SIZE_OVER_LARGE + 4,
                  ),
                  Text(
                    'Guest'.tr,
                    style: robotoBold.copyWith(fontSize: 24),
                  ),
                  SizedBox(
                    height: Dimensions.PADDING_SIZE_LARGE + 12,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
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
                    child: Column(
                      children: [
                        if (isRegister)
                          CustomTextField(
                            hintText: 'Guest name'.tr,
                            controller: _nameController,
                            focusNode: _nameFocus,
                            nextFocus: _emailFocus,
                            inputType: TextInputType.emailAddress,
                            prefixIcon: 'assets/image/ic_user.png',
                            divider: false,
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE,
                          ),
                          child: Divider(height: 1),
                        ),
                        CustomTextField(
                          hintText: 'email'.tr,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.mail,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.PADDING_SIZE_EXTRA_SMALL + 6,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          '${isRegister ? 'If you have already guest account,'.tr : 'If you dont have guest account,'.tr}',
                          style: robotoRegular.copyWith(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _nameController.text = '';
                              _emailController.text = '';
                              isRegister = !isRegister;
                            });
                          },
                          child: Text(
                            '${isRegister ? 'Login'.tr : 'Register'.tr}',
                            style: robotoMedium.copyWith(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    height: 44,
                    margin: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    child: CustomButton(
                      buttonText: 'Continue'.tr,
                      height: 44,
                      radius: 30,
                      onPressed: () async {
                        var chk = checkEmpty();
                        if (chk.isEmpty) {
                          if (isRegister) {
                            guestRegister();
                          } else {
                            guestLogin();
                          }
                        } else {
                          showCustomSnackBar('$chk');
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  String checkEmpty() {
    String chk = '';
    if (_emailController.text.isNotEmpty) {
      if (isRegister) {
        if (_nameController.text.isEmpty) {
          chk = '${'Please fill name field.'.tr}';
        }
      }
    } else {
      chk = '${'Please fill email field.'.tr}';
    }
    return chk;
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    } else {
      onTap();
    }
  }

  void guestLogin() {
    setState(() {
      isLoading = true;
    });
    Get.find<AuthController>().loginGuest(_emailController.text).then(
      (status) async {
        setState(() {
          isLoading = false;
        });
        if (status.isSuccess) {
          if (Get.find<LocationController>().getUserAddress() != null) {
            Get.offAndToNamed(RouteHelper.getInitialRoute());
          } else {
            Get.toNamed(
              RouteHelper.getAccessLocationRoute('sign-in'),
            );
          }
        } else {
          showCustomSnackBar(
              '${'Login failed, please check entered email'.tr}');
        }
      },
    );
  }

  void guestRegister() {
    var deviceId = Get.find<AuthController>().deviceId;
    SignUpBody signUpBody = SignUpBody(
      fName: '${_nameController.text}',
      lName: '$deviceId',
      email: '${_emailController.text}',
      phone: '',
      password: '$deviceId',
      refCode: '',
    );
    setState(() {
      isLoading = true;
    });
    Get.find<AuthController>().registerGuest(signUpBody).then(
      (status) async {
        if (status.isSuccess) {
          setState(() {
            isLoading = false;
          });
          if (Get.find<LocationController>().getUserAddress() != null) {
            Get.offAndToNamed(RouteHelper.getInitialRoute());
          } else {
            Get.toNamed(
              RouteHelper.getAccessLocationRoute('sign-in'),
            );
          }
        } else {
          setState(() {
            isLoading = false;
          });
          showCustomSnackBar('${status.message}');
        }
      },
    );
  }
}
