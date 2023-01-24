import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/location/pick_map_screen.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  final bool fromCheckout;
  final AddressModel address;

  AddAddressScreen({@required this.fromCheckout, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController personNameCtrl = TextEditingController();
  final TextEditingController companyName = TextEditingController();
  final TextEditingController phoneNumberCtrl = TextEditingController();
  final TextEditingController houseNumberCtrl = TextEditingController();
  final TextEditingController streetNumberCtrl = TextEditingController();
  final TextEditingController villageCtrl = TextEditingController();
  final TextEditingController aptNumberCtrl = TextEditingController();
  final TextEditingController floorNumCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final FocusNode nameNode = FocusNode();
  final FocusNode companyNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode houseNode = FocusNode();
  final FocusNode streetNumNode = FocusNode();
  final FocusNode villageNode = FocusNode();
  final FocusNode aptNode = FocusNode();
  final FocusNode floorNode = FocusNode();
  final FocusNode addressNode = FocusNode();

  bool _isLoggedIn;
  CameraPosition _cameraPosition;
  LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    personNameCtrl.text = '';
    companyName.text = '';
    phoneNumberCtrl.text = '';
    houseNumberCtrl.text = '';
    streetNumberCtrl.text = '';
    villageCtrl.text = '';
    aptNumberCtrl.text = '';
    floorNumCtrl.text = '';
    addressCtrl.text = '';

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    if (widget.address == null) {
      _initialPosition = LatLng(
        double.parse(
            Get.find<SplashController>().configModel.defaultLocation.lat ??
                '0'),
        double.parse(
            Get.find<SplashController>().configModel.defaultLocation.lng ??
                '0'),
      );
    } else {
      Get.find<LocationController>().setUpdateAddress(widget.address);
      _initialPosition = LatLng(
        double.parse(widget.address.latitude ?? '0'),
        double.parse(widget.address.longitude ?? '0'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 22,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '${'add'.tr} ${'address'.tr}',
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
          SizedBox(
            height: Dimensions.PADDING_SIZE_SMALL,
          ),
          Expanded(
            child: _isLoggedIn
                ? GetBuilder<UserController>(
                    builder: (userController) {
                      if (widget.address != null) {
                        if (personNameCtrl.text.isEmpty) {
                          personNameCtrl.text =
                              widget.address.contactPersonName;
                          phoneNumberCtrl.text =
                              widget.address.contactPersonNumber;
                          houseNumberCtrl.text = widget.address.house;
                          streetNumberCtrl.text = widget.address.road;
                          floorNumCtrl.text = widget.address.floor;
                          villageCtrl.text = widget.address.villageName;
                          aptNumberCtrl.text = widget.address.aptNumber;
                          companyName.text = widget.address.companyName;
                        }
                      } else if (userController.userInfoModel != null) {
                        personNameCtrl.text =
                            '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}';
                        phoneNumberCtrl.text =
                            userController.userInfoModel.phone;
                      }

                      return GetBuilder<LocationController>(
                        builder: (locationController) {
                          if (locationController.address != null) {
                            addressCtrl.text = locationController.address;
                          }

                          return Column(
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        width: Dimensions.WEB_MAX_WIDTH,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 140,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Dimensions.RADIUS_SMALL,
                                                ),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Dimensions.RADIUS_SMALL,
                                                ),
                                                child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      GoogleMap(
                                                        initialCameraPosition:
                                                            CameraPosition(
                                                          target:
                                                              _initialPosition,
                                                          zoom: 17,
                                                        ),
                                                        minMaxZoomPreference:
                                                            MinMaxZoomPreference(
                                                                0, 16),
                                                        onTap: (latLng) {
                                                          Get.toNamed(
                                                            RouteHelper
                                                                .getPickMapRoute(
                                                              'add-address',
                                                              false,
                                                            ),
                                                            arguments:
                                                                PickMapScreen(
                                                              fromAddAddress:
                                                                  true,
                                                              fromSignUp: false,
                                                              googleMapController:
                                                                  locationController
                                                                      .mapController,
                                                              route: null,
                                                              canRoute: false,
                                                            ),
                                                          );
                                                        },
                                                        zoomControlsEnabled:
                                                            false,
                                                        compassEnabled: false,
                                                        indoorViewEnabled: true,
                                                        mapToolbarEnabled:
                                                            false,
                                                        onCameraIdle: () {
                                                          locationController
                                                              .updatePosition(
                                                                  _cameraPosition,
                                                                  true);
                                                        },
                                                        onCameraMove:
                                                            ((position) =>
                                                                _cameraPosition =
                                                                    position),
                                                        onMapCreated:
                                                            (GoogleMapController
                                                                controller) {
                                                          locationController
                                                              .setMapController(
                                                                  controller);
                                                          if (widget.address ==
                                                              null) {
                                                            locationController
                                                                .getCurrentLocation(
                                                              true,
                                                              mapController:
                                                                  controller,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      locationController.loading
                                                          ? Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : SizedBox(),
                                                      Center(
                                                        child: !locationController
                                                                .loading
                                                            ? Image.asset(
                                                                Images
                                                                    .pick_marker,
                                                                height: 50,
                                                                width: 50)
                                                            : CircularProgressIndicator(),
                                                      ),
                                                      Positioned(
                                                        bottom: 10,
                                                        right: 0,
                                                        child: InkWell(
                                                          onTap: () =>
                                                              _checkPermission(
                                                            () {
                                                              locationController
                                                                  .getCurrentLocation(
                                                                true,
                                                                mapController:
                                                                    locationController
                                                                        .mapController,
                                                              );
                                                            },
                                                          ),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            margin:
                                                                EdgeInsets.only(
                                                              right: Dimensions
                                                                  .PADDING_SIZE_LARGE,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                Dimensions
                                                                    .RADIUS_SMALL,
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Icon(
                                                              Icons.my_location,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 10,
                                                        right: 0,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.toNamed(
                                                              RouteHelper
                                                                  .getPickMapRoute(
                                                                      'add-address',
                                                                      false),
                                                              arguments:
                                                                  PickMapScreen(
                                                                fromAddAddress:
                                                                    true,
                                                                fromSignUp:
                                                                    false,
                                                                googleMapController:
                                                                    locationController
                                                                        .mapController,
                                                                route: null,
                                                                canRoute: false,
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            margin:
                                                                EdgeInsets.only(
                                                              right: Dimensions
                                                                  .PADDING_SIZE_LARGE,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                Dimensions
                                                                    .RADIUS_SMALL,
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Icon(
                                                              Icons.fullscreen,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            Center(
                                              child: Text(
                                                'add_the_location_correctly'.tr,
                                                style: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_LARGE,
                                            ),
                                            Text(
                                              'label_as'.tr,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: locationController
                                                    .addressTypeList.length,
                                                itemBuilder: (context, index) =>
                                                    InkWell(
                                                  onTap: () {
                                                    locationController
                                                        .setAddressTypeIndex(
                                                            index);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_LARGE,
                                                      vertical: Dimensions
                                                          .PADDING_SIZE_SMALL,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      right: Dimensions
                                                          .PADDING_SIZE_SMALL,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        Dimensions.RADIUS_SMALL,
                                                      ),
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey[
                                                              Get.isDarkMode
                                                                  ? 800
                                                                  : 200],
                                                          spreadRadius: 1,
                                                          blurRadius: 5,
                                                        )
                                                      ],
                                                    ),
                                                    child: Row(children: [
                                                      Icon(
                                                        index == 0
                                                            ? Icons.home_filled
                                                            : index == 1
                                                                ? Icons.work
                                                                : Icons
                                                                    .location_on,
                                                        color:
                                                            locationController
                                                                        .addressTypeIndex ==
                                                                    index
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL,
                                                      ),
                                                      Text(
                                                        locationController
                                                            .addressTypeList[
                                                                index]
                                                            .tr,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          color: locationController
                                                                      .addressTypeIndex ==
                                                                  index
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .color
                                                              : Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_LARGE,
                                            ),
                                            Text(
                                              'Name of Person'.tr,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4,
                                              ),
                                              child: MyTextField(
                                                hintText: 'full_name'.tr,
                                                inputType: TextInputType.name,
                                                controller: personNameCtrl,
                                                focusNode: nameNode,
                                                nextFocus: phoneNode,
                                                capitalization:
                                                    TextCapitalization.words,
                                              ),
                                            ),
                                            if (locationController
                                                    .addressTypeIndex ==
                                                1)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_LARGE,
                                                  ),
                                                  Text(
                                                    'Company Name'.tr,
                                                    style:
                                                        robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 4,
                                                    ),
                                                    child: MyTextField(
                                                      hintText:
                                                          'Company Name'.tr,
                                                      inputType:
                                                          TextInputType.name,
                                                      controller: companyName,
                                                      focusNode: companyNode,
                                                      nextFocus: phoneNode,
                                                      capitalization:
                                                          TextCapitalization
                                                              .words,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_LARGE,
                                            ),
                                            Text(
                                              '${'phone'.tr} ${'number'.tr}',
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4,
                                              ),
                                              child: MyTextField(
                                                hintText:
                                                    '${'phone'.tr} ${'number'.tr}',
                                                inputType: TextInputType.phone,
                                                focusNode: phoneNode,
                                                nextFocus: houseNode,
                                                controller: phoneNumberCtrl,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_LARGE,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 120,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${'house'.tr} ${'number'.tr}',
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                      ),
                                                      MyTextField(
                                                        hintText:
                                                            '${'house'.tr} ${'number'.tr}',
                                                        inputType:
                                                            TextInputType.phone,
                                                        focusNode: houseNode,
                                                        nextFocus:
                                                            streetNumNode,
                                                        controller:
                                                            houseNumberCtrl,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Street Name'.tr,
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor),
                                                      ),
                                                      SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                      ),
                                                      MyTextField(
                                                        hintText:
                                                            'Street Name'.tr,
                                                        inputType: TextInputType
                                                            .streetAddress,
                                                        focusNode:
                                                            streetNumNode,
                                                        nextFocus: villageNode,
                                                        controller:
                                                            streetNumberCtrl,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Dimensions
                                                      .PADDING_SIZE_SMALL +
                                                  6,
                                            ),
                                            Text(
                                              'Village Name'.tr,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            SizedBox(
                                              height: 48,
                                              child: MyTextField(
                                                hintText: 'Village Name'.tr,
                                                inputType:
                                                    TextInputType.streetAddress,
                                                focusNode: villageNode,
                                                nextFocus: aptNode,
                                                controller: villageCtrl,
                                              ),
                                            ),
                                            SizedBox(
                                              height: Dimensions
                                                      .PADDING_SIZE_SMALL +
                                                  6,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 120,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${'Apt'.tr} ${'number'.tr}',
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                      ),
                                                      MyTextField(
                                                        hintText:
                                                            '${'Apt'.tr} ${'number'.tr}',
                                                        inputType:
                                                            TextInputType.phone,
                                                        focusNode: aptNode,
                                                        nextFocus: floorNode,
                                                        controller:
                                                            aptNumberCtrl,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Floor Number'.tr,
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor),
                                                      ),
                                                      SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                      ),
                                                      SizedBox(
                                                        height: 48,
                                                        child: MyTextField(
                                                          hintText:
                                                              'Floor Number'.tr,
                                                          inputType:
                                                              TextInputType
                                                                  .phone,
                                                          focusNode: floorNode,
                                                          inputAction:
                                                              TextInputAction
                                                                  .done,
                                                          controller:
                                                              floorNumCtrl,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_LARGE,
                                            ),
                                            Text(
                                              'Address Line 3'.tr,
                                              style: robotoRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                  RouteHelper.getPickMapRoute(
                                                    'add-address',
                                                    false,
                                                  ),
                                                  arguments: PickMapScreen(
                                                    fromAddAddress: true,
                                                    fromSignUp: false,
                                                    googleMapController:
                                                        locationController
                                                            .mapController,
                                                    route: null,
                                                    canRoute: false,
                                                  ),
                                                );
                                              },
                                              child: MyTextField(
                                                hintText: 'delivery_address'.tr,
                                                inputType:
                                                    TextInputType.streetAddress,
                                                focusNode: addressNode,
                                                nextFocus: nameNode,
                                                controller: addressCtrl,
                                                isEnabled: false,
                                                onChanged: (text) =>
                                                    locationController
                                                        .setPlaceMark(text),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_LARGE,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: Dimensions.WEB_MAX_WIDTH,
                                padding: EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_SMALL,
                                ),
                                child: !locationController.isLoading
                                    ? CustomButton(
                                        buttonText: widget.address == null
                                            ? 'save_location'.tr
                                            : 'update_address'.tr,
                                        onPressed: () {
                                          var chk = checkEmpty(
                                              locationController
                                                  .addressTypeIndex);
                                          if (chk == '') {
                                            if (!locationController.loading) {
                                              AddressModel _addressModel =
                                                  AddressModel(
                                                id: widget.address != null
                                                    ? widget.address.id
                                                    : null,
                                                addressType: locationController
                                                        .addressTypeList[
                                                    locationController
                                                        .addressTypeIndex],
                                                contactPersonName:
                                                    personNameCtrl.text ?? '',
                                                contactPersonNumber:
                                                    phoneNumberCtrl.text ?? '',
                                                companyName: companyName.text,
                                                latitude: locationController
                                                        .position.latitude
                                                        .toString() ??
                                                    '',
                                                longitude: locationController
                                                        .position.longitude
                                                        .toString() ??
                                                    '',
                                                zoneId:
                                                    locationController.zoneID,
                                                house:
                                                    houseNumberCtrl.text.trim(),
                                                road: streetNumberCtrl.text
                                                    .trim(),
                                                floor: floorNumCtrl.text.trim(),
                                                villageName: villageCtrl.text,
                                                aptNumber: aptNumberCtrl.text,
                                                address: addressCtrl.text ?? '',
                                              );
                                              if (widget.address == null) {
                                                locationController
                                                    .addAddress(_addressModel,
                                                        widget.fromCheckout)
                                                    .then((response) {
                                                  if (response.isSuccess) {
                                                    Get.back(
                                                        result: _addressModel);
                                                    showCustomSnackBar(
                                                        'new_address_added_successfully'
                                                            .tr,
                                                        isError: false);
                                                  } else {
                                                    showCustomSnackBar(
                                                        response.message);
                                                  }
                                                });
                                              } else {
                                                locationController
                                                    .updateAddress(
                                                        _addressModel,
                                                        widget.address.id)
                                                    .then((response) {
                                                  if (response.isSuccess) {
                                                    Get.back();
                                                    showCustomSnackBar(
                                                        response.message,
                                                        isError: false);
                                                  } else {
                                                    showCustomSnackBar(
                                                        response.message);
                                                  }
                                                });
                                              }
                                            }
                                          } else {
                                            showCustomSnackBar('$chk');
                                          }
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : NotLoggedInScreen(),
          ),
        ],
      ),
    );
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

  String checkEmpty(int __typeIndex) {
    var chk = '';
    if (addressCtrl.text.isEmpty) {
      chk = 'Please choose address line 3'.tr;
    }
    if (floorNumCtrl.text.isEmpty) {
      chk = 'Please enter floor number'.tr;
    }
    if (aptNumberCtrl.text.isEmpty) {
      chk = 'Please enter Apt name'.tr;
    }
    if (villageCtrl.text.isEmpty) {
      chk = 'Please enter village name'.tr;
    }
    if (streetNumberCtrl.text.isEmpty) {
      chk = 'Please enter street name'.tr;
    }
    if (houseNumberCtrl.text.isEmpty) {
      chk = 'Please enter house number'.tr;
    }
    if (phoneNumberCtrl.text.isEmpty) {
      chk = 'Please enter phone number'.tr;
    }
    if (personNameCtrl.text.isEmpty) {
      chk = 'Please enter person name'.tr;
    }
    if (__typeIndex == 1 && companyName.text.isEmpty) {
      chk = 'Please enter company name'.tr;
    }
    return chk;
  }
}
