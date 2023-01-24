import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/cart/widget/delivery_option_button.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/slot_widget.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/tips_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:universal_html/html.dart' as html;

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromCart;
  final int orderType;

  CheckoutScreen({
    @required this.fromCart,
    @required this.cartList,
    this.orderType = 0,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _noteController = TextEditingController();
  TextEditingController _tipController = TextEditingController();
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isWalletActive;
  bool _isLoggedIn;
  List<CartModel> _cartList;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      if (Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      if (Get.find<LocationController>().addressList == null ||
          Get.find<LocationController>().addressList.isEmpty) {
        Get.find<LocationController>().getAddressList();
      }
      _isCashOnDeliveryActive =
          Get.find<SplashController>().configModel.cashOnDelivery;
      _isDigitalPaymentActive =
          Get.find<SplashController>().configModel.digitalPayment;
      _isWalletActive =
          Get.find<SplashController>().configModel.customerWalletStatus == 1;
      _cartList = [];
      widget.cartList == null
          ? _cartList.addAll(Get.find<CartController>().cartList)
          : _cartList.addAll(widget.cartList);
      Get.find<RestaurantController>()
          .initCheckoutData(_cartList[0].product.restaurantId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'checkout'.tr),
      body: _isLoggedIn
          ? GetBuilder<LocationController>(builder: (locationController) {
              return GetBuilder<RestaurantController>(
                  builder: (restaurantController) {
                return GetBuilder<CouponController>(
                    builder: (couponController) {
                  return GetBuilder<OrderController>(
                      builder: (orderController) {
                    orderController.setPaymentMethod(1);
                    Restaurant _restaurant;
                    int venueId;
                    if (_cartList.length > 0) {
                      venueId = _cartList[0].product.restaurantId;
                      if (restaurantController.restaurantModel != null &&
                          restaurantController
                              .restaurantModel.restaurants.isNotEmpty) {
                        restaurantController.restaurantModel.restaurants
                            .forEach((venue) {
                          if (venue.id == venueId) {
                            _restaurant = venue.copyWith();
                          }
                        });
                      }
                    }
                    List<DropdownMenuItem<int>> _addressList = [];
                    var addrrIndex = 0;
                    AddressModel __address =
                        locationController.getUserAddress();
                    if (locationController.addressList != null &&
                        locationController.addressList.isNotEmpty) {
                      locationController.addressList.forEach((addrr) {
                        if (__address.zoneIds.contains(addrr.zoneId)) {
                          _addressList.add(
                            DropdownMenuItem<int>(
                              value: addrrIndex,
                              child: SizedBox(
                                width: sWidth - 50,
                                child: AddressWidget(
                                  address: addrr,
                                  fromAddress: false,
                                  fromCheckout: true,
                                ),
                              ),
                            ),
                          );
                          addrrIndex++;
                        }
                      });
                    }

                    bool _todayClosed = false;
                    bool _tomorrowClosed = false;
                    if (_restaurant != null) {
                      _todayClosed = restaurantController.isRestaurantClosed(
                          true, _restaurant.status, _restaurant.schedules);
                      _tomorrowClosed = restaurantController.isRestaurantClosed(
                          false, _restaurant.status, _restaurant.schedules);
                    }

                    double _deliveryCharge = -1;
                    if (_restaurant != null &&
                        _restaurant.selfDeliverySystem == 1) {
                      _deliveryCharge = _restaurant.deliveryCharge;
                    } else if (_restaurant != null &&
                        orderController.distance != null &&
                        orderController.distance != -1) {
                      _deliveryCharge = orderController.distance *
                          Get.find<SplashController>()
                              .configModel
                              .perKmShippingCharge;
                      if (_deliveryCharge <
                          Get.find<SplashController>()
                              .configModel
                              .minimumShippingCharge) {
                        _deliveryCharge = Get.find<SplashController>()
                            .configModel
                            .minimumShippingCharge;
                      }
                    }

                    double _itemPrice = 0;
                    double _addOns = 0;
                    double _subTotal = 0;
                    double _totalTaxAmount = 0;
                    double _orderAmount = 0;

                    if (_restaurant != null) {
                      _cartList.forEach((cartModel) {
                        List<AddOns> _addOnList = [];
                        cartModel.addOnIds.forEach((addOnId) {
                          for (AddOns addOn in cartModel.product.addOns) {
                            if (addOn.id == addOnId.id) {
                              _addOnList.add(addOn);
                              _addOns =
                                  _addOns + (addOn.price * addOnId.quantity);
                              break;
                            }
                          }
                        });
                        _itemPrice =
                            _itemPrice + (cartModel.price * cartModel.quantity);
                      });

                      _subTotal = _itemPrice + _addOns;
                      _orderAmount = _subTotal;

                      if (orderController.orderType == 'take_away' ||
                          _restaurant.freeDelivery ||
                          (Get.find<SplashController>()
                                      .configModel
                                      .freeDeliveryOver !=
                                  null &&
                              _orderAmount >=
                                  Get.find<SplashController>()
                                      .configModel
                                      .freeDeliveryOver) ||
                          couponController.freeDelivery) {
                        _deliveryCharge = 0;
                      }
                    }

                    _totalTaxAmount = 0;
                    double _tax = 0, _taxAmount = 0;
                    double _serviceCharge = 0, _serviceChargeAmount = 0;
                    double _promo = 0, _promoAmount = 0;
                    double _serverTip = 0, _serverTipAmount = 0;
                    double _deliveryTip = 0, _deliveryTipAmount = 0;

                    if (_restaurant != null) {
                      _tax = _restaurant.tax;
                      if (_tax > 0) {
                        _taxAmount = (_subTotal * _tax) / 100;
                        _totalTaxAmount += _taxAmount;
                      }

                      _serviceCharge = _restaurant.serviceCharge;
                      if (_serviceCharge > 0) {
                        _serviceChargeAmount =
                            (_subTotal * _serviceCharge) / 100;
                        _totalTaxAmount += _serviceChargeAmount;
                      }

                      _promo = _restaurant.promo;
                      if (_promo > 0) {
                        _promoAmount = (_subTotal * _promo) / 100;
                        _totalTaxAmount += _promoAmount;
                      }

                      _serverTip = _restaurant.serverTip;
                      if (_serverTip > 0) {
                        _serverTipAmount = (_subTotal * _serverTip) / 100;
                        _totalTaxAmount += _serverTipAmount;
                      }
                    }

                    if (orderController.orderType != 'take_away' &&
                        Get.find<SplashController>().configModel.dmTipsStatus ==
                            1) {
                      _deliveryTip = orderController.tips;
                      _deliveryTipAmount = _deliveryTip;
                      _totalTaxAmount += _deliveryTip;
                    }

                    double _total =
                        _subTotal + _deliveryCharge + _totalTaxAmount;

                    print('=== orderType: ${orderController.orderType}');

                    return (orderController.distance != null &&
                            locationController.addressList.isNotEmpty)
                        ? Column(
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
                                            SizedBox(height: 12,),
                                            // Order type
                                            Text('delivery_option'.tr,
                                                style: robotoMedium),
                                            _restaurant.delivery
                                                ? DeliveryOptionButton(
                                                    value: 'delivery',
                                                    title: 'Delivery'.tr,
                                                    charge: _deliveryCharge,
                                                    isFree: _restaurant
                                                        .freeDelivery,
                                                  )
                                                : SizedBox(),
                                            _restaurant.takeAway
                                                ? DeliveryOptionButton(
                                                    value: 'take_away',
                                                    title: 'Pick-Up'.tr,
                                                    charge: _deliveryCharge,
                                                    isFree: true,
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_LARGE,
                                            ),

                                            orderController.orderType !=
                                                    'take_away'
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'deliver_to'.tr,
                                                                style:
                                                                    robotoMedium),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        _addressList.isNotEmpty
                                                            ? Container(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    DropdownButton(
                                                                  value: locationController
                                                                      .addressIndex,
                                                                  items:
                                                                      _addressList,
                                                                  itemHeight:
                                                                      116,
                                                                  elevation: 0,
                                                                  iconSize: 30,
                                                                  underline:
                                                                      SizedBox(),
                                                                  onChanged: (int
                                                                      index) {
                                                                    if (_restaurant
                                                                            .selfDeliverySystem ==
                                                                        0) {
                                                                      orderController
                                                                          .getDistanceInMeter(
                                                                        LatLng(
                                                                          double.parse(index == -1
                                                                              ? locationController.getUserAddress().latitude
                                                                              : locationController.addressList[index].latitude),
                                                                          double.parse(index == -1
                                                                              ? locationController.getUserAddress().longitude
                                                                              : locationController.addressList[index].longitude),
                                                                        ),
                                                                        LatLng(
                                                                            double.parse(_restaurant.latitude),
                                                                            double.parse(
                                                                              _restaurant.longitude,
                                                                            )),
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_LARGE,
                                                        ),
                                                      ])
                                                : SizedBox(),
                                            SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_LARGE),

                                            // Time Slot
                                            _restaurant.scheduleOrder
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                        Text(
                                                            'preference_time'
                                                                .tr,
                                                            style:
                                                                robotoMedium),
                                                        SizedBox(
                                                            height: Dimensions
                                                                .PADDING_SIZE_SMALL),
                                                        SizedBox(
                                                          height: 50,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            shrinkWrap: true,
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            itemCount: 2,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return SlotWidget(
                                                                title: index ==
                                                                        0
                                                                    ? 'today'.tr
                                                                    : 'tomorrow'
                                                                        .tr,
                                                                isSelected:
                                                                    orderController
                                                                            .selectedDateSlot ==
                                                                        index,
                                                                onTap: () =>
                                                                    orderController
                                                                        .updateDateSlot(
                                                                            index),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Dimensions
                                                                .PADDING_SIZE_SMALL),
                                                        SizedBox(
                                                          height: 50,
                                                          child: ((orderController
                                                                              .selectedDateSlot ==
                                                                          0 &&
                                                                      _todayClosed) ||
                                                                  (orderController
                                                                              .selectedDateSlot ==
                                                                          1 &&
                                                                      _tomorrowClosed))
                                                              ? Center(
                                                                  child: Text(
                                                                      'restaurant_is_closed'
                                                                          .tr),
                                                                )
                                                              : orderController
                                                                          .timeSlots !=
                                                                      null
                                                                  ? orderController
                                                                              .timeSlots
                                                                              .length >
                                                                          0
                                                                      ? ListView
                                                                          .builder(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              BouncingScrollPhysics(),
                                                                          itemCount: orderController
                                                                              .timeSlots
                                                                              .length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return SlotWidget(
                                                                              title: (index == 0 && orderController.selectedDateSlot == 0 && restaurantController.isRestaurantOpenNow(_restaurant.status, _restaurant.schedules))
                                                                                  ? 'now'.tr
                                                                                  : '${DateConverter.dateToTimeOnly(orderController.timeSlots[index].startTime)} '
                                                                                      '- ${DateConverter.dateToTimeOnly(orderController.timeSlots[index].endTime)}',
                                                                              isSelected: orderController.selectedTimeSlot == index,
                                                                              onTap: () => orderController.updateTimeSlot(index),
                                                                            );
                                                                          },
                                                                        )
                                                                      : Center(
                                                                          child:
                                                                              Text('no_slot_available'.tr),
                                                                        )
                                                                  : Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    ),
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_LARGE,
                                                        ),
                                                      ])
                                                : SizedBox(),
                                            SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_LARGE),

                                            (orderController.orderType !=
                                                        'take_away' &&
                                                    Get.find<SplashController>()
                                                            .configModel
                                                            .dmTipsStatus ==
                                                        1)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                        Text(
                                                          'delivery_man_tips'
                                                              .tr,
                                                          style: robotoMedium,
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_SMALL,
                                                        ),
                                                        Container(
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              Dimensions
                                                                  .RADIUS_SMALL,
                                                            ),
                                                          ),
                                                          child: TextField(
                                                            controller:
                                                                _tipController,
                                                            onChanged:
                                                                (String value) {
                                                              if (value
                                                                  .isNotEmpty) {
                                                                orderController
                                                                    .addTips(
                                                                  double.parse(
                                                                      value),
                                                                );
                                                              } else {
                                                                orderController
                                                                    .addTips(
                                                                        0.0);
                                                              }
                                                            },
                                                            maxLength: 10,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(
                                                                RegExp(
                                                                    r'[0-9.]'),
                                                              )
                                                            ],
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'enter_amount'
                                                                      .tr,
                                                              counterText: '',
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  Dimensions
                                                                      .RADIUS_SMALL,
                                                                ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_SMALL,
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            shrinkWrap: true,
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            itemCount:
                                                                AppConstants
                                                                    .tips
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return TipsWidget(
                                                                title: AppConstants
                                                                    .tips[index]
                                                                    .toString(),
                                                                isSelected:
                                                                    orderController
                                                                            .selectedTips ==
                                                                        index,
                                                                onTap: () {
                                                                  orderController
                                                                      .updateTips(
                                                                          index);
                                                                  orderController.addTips(
                                                                      AppConstants
                                                                          .tips[
                                                                              index]
                                                                          .toDouble());
                                                                  _tipController
                                                                          .text =
                                                                      orderController
                                                                          .tips
                                                                          .toString();
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ])
                                                : SizedBox.shrink(),
                                            SizedBox(
                                                height: (orderController
                                                                .orderType !=
                                                            'take_away' &&
                                                        Get.find<SplashController>()
                                                                .configModel
                                                                .dmTipsStatus ==
                                                            1)
                                                    ? Dimensions
                                                        .PADDING_SIZE_LARGE
                                                    : 0),

                                            // Text(
                                            //   'choose_payment_method'.tr,
                                            //   style: robotoMedium,
                                            // ),
                                            // SizedBox(
                                            //   height:
                                            //       Dimensions.PADDING_SIZE_SMALL,
                                            // ),
                                            // _isCashOnDeliveryActive
                                            //     ? PaymentButton(
                                            //         icon:
                                            //             Images.cash_on_delivery,
                                            //         title:
                                            //             'cash_on_delivery'.tr,
                                            //         subtitle:
                                            //             'pay_your_payment_after_getting_food'
                                            //                 .tr,
                                            //         index: 0,
                                            //       )
                                            //     : SizedBox(),
                                            // _isDigitalPaymentActive
                                            //     ? PaymentButton(
                                            //         icon:
                                            //             Images.digital_payment,
                                            //         title: 'digital_payment'.tr,
                                            //         subtitle:
                                            //             'faster_and_safe_way'
                                            //                 .tr,
                                            //         index: 1,
                                            //       )
                                            //     : SizedBox(),
                                            SizedBox(
                                              height:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),

                                            CustomTextField(
                                              controller: _noteController,
                                              hintText: 'additional_note'.tr,
                                              maxLines: 3,
                                              inputType:
                                                  TextInputType.multiline,
                                              inputAction:
                                                  TextInputAction.newline,
                                              capitalization:
                                                  TextCapitalization.sentences,
                                            ),

                                            SizedBox(
                                              height: 24,
                                            ),

                                            Text(
                                              'Recipe Details'.tr,
                                              style: robotoMedium,
                                            ),

                                            SizedBox(
                                              height: 12,
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 8,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'item_price'.tr,
                                                          style: robotoRegular,
                                                        ),
                                                        Text(
                                                          '\$${_itemPrice.toStringAsFixed(2)}',
                                                          style: robotoRegular,
                                                        ),
                                                      ]),
                                                  SizedBox(height: 6),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'addons'.tr,
                                                          style: robotoRegular,
                                                        ),
                                                        Text(
                                                          '\$${_addOns.toStringAsFixed(2)}',
                                                          style: robotoRegular,
                                                        ),
                                                      ]),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 10,
                                                      top: 12,
                                                    ),
                                                    child: DottedLine(
                                                      dashColor:
                                                          Theme.of(context)
                                                              .disabledColor,
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'subtotal'.tr,
                                                          style: robotoMedium,
                                                        ),
                                                        Text(
                                                          '\$${_subTotal.toStringAsFixed(2)}',
                                                          style: robotoMedium,
                                                        ),
                                                      ]),
                                                  SizedBox(
                                                    height: 22,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${'Server Tip'.tr} ($_serverTip%):',
                                                          style: robotoRegular,
                                                        ),
                                                        Text(
                                                            '(+) \$${_serverTipAmount.toStringAsFixed(2)}',
                                                            style:
                                                                robotoRegular),
                                                      ]),
                                                  SizedBox(height: 10),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${'Service Charge'.tr} ($_serviceCharge%):',
                                                          style: robotoRegular,
                                                        ),
                                                        Text(
                                                          '(+) \$${_serviceChargeAmount.toStringAsFixed(2)}',
                                                          style: robotoRegular,
                                                        ),
                                                      ]),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${'vat_tax'.tr} ($_tax%):',
                                                        style: robotoRegular,
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        '(+) \$${_taxAmount.toStringAsFixed(2)}',
                                                        style: robotoRegular,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${'Promo'.tr} ($_promo%):',
                                                        style: robotoRegular,
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        '(+) \$${_promoAmount.toStringAsFixed(2)}',
                                                        style: robotoRegular,
                                                      ),
                                                    ],
                                                  ),
                                                  if (orderController
                                                              .orderType !=
                                                          'take_away' &&
                                                      Get.find<SplashController>()
                                                              .configModel
                                                              .dmTipsStatus ==
                                                          1)
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                            height: Dimensions
                                                                .PADDING_SIZE_SMALL),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'delivery_man_tips'
                                                                    .tr,
                                                                style:
                                                                    robotoRegular),
                                                            Text(
                                                                '(+) \$${_deliveryTipAmount.toStringAsFixed(2)}',
                                                                style:
                                                                    robotoRegular),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Delivery Charge'.tr,
                                                        style: robotoRegular,
                                                      ),
                                                      _deliveryCharge == -1
                                                          ? Text(
                                                              'calculating'.tr,
                                                              style: robotoRegular
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .red),
                                                            )
                                                          : (_deliveryCharge ==
                                                                      0 ||
                                                                  (couponController
                                                                              .coupon !=
                                                                          null &&
                                                                      couponController
                                                                              .coupon
                                                                              .couponType ==
                                                                          'free_delivery'))
                                                              ? Text(
                                                                  'free'.tr,
                                                                  style: robotoRegular
                                                                      .copyWith(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                )
                                                              : Text(
                                                                  '(+) \$${_deliveryCharge.toStringAsFixed(2)}',
                                                                  style:
                                                                      robotoRegular,
                                                                ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .PADDING_SIZE_SMALL,
                                                    ),
                                                    child: Divider(
                                                      thickness: 1,
                                                      color: Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'total_amount'.tr,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      Text(
                                                        '\$${_total.toStringAsFixed(2)}',
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
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
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: !orderController.isLoading
                                    ? CustomButton(
                                        buttonText: 'confirm_order'.tr,
                                        onPressed: () {
                                          bool _isAvailable = true;
                                          DateTime _scheduleStartDate =
                                              DateTime.now();
                                          DateTime _scheduleEndDate =
                                              DateTime.now();
                                          print(
                                              '=== timeslot: ${orderController.timeSlots}');
                                          if (orderController.timeSlots ==
                                                  null ||
                                              orderController
                                                      .timeSlots.length ==
                                                  0) {
                                            _isAvailable = false;
                                          } else {
                                            DateTime _date = orderController
                                                        .selectedDateSlot ==
                                                    0
                                                ? DateTime.now()
                                                : DateTime.now()
                                                    .add(Duration(days: 1));
                                            DateTime _startTime =
                                                orderController
                                                    .timeSlots[orderController
                                                        .selectedTimeSlot]
                                                    .startTime;
                                            DateTime _endTime = orderController
                                                .timeSlots[orderController
                                                    .selectedTimeSlot]
                                                .endTime;
                                            _scheduleStartDate = DateTime(
                                                _date.year,
                                                _date.month,
                                                _date.day,
                                                _startTime.hour,
                                                _startTime.minute + 1);
                                            _scheduleEndDate = DateTime(
                                                _date.year,
                                                _date.month,
                                                _date.day,
                                                _endTime.hour,
                                                _endTime.minute + 1);
                                            for (CartModel cart in _cartList) {
                                              if (!DateConverter.isAvailable(
                                                    cart.product
                                                        .availableTimeStarts,
                                                    cart.product
                                                        .availableTimeEnds,
                                                    time: _restaurant
                                                            .scheduleOrder
                                                        ? _scheduleStartDate
                                                        : null,
                                                  ) &&
                                                  !DateConverter.isAvailable(
                                                    cart.product
                                                        .availableTimeStarts,
                                                    cart.product
                                                        .availableTimeEnds,
                                                    time: _restaurant
                                                            .scheduleOrder
                                                        ? _scheduleEndDate
                                                        : null,
                                                  )) {
                                                _isAvailable = false;
                                                break;
                                              }
                                            }
                                          }
                                          if (!_isCashOnDeliveryActive &&
                                              !_isDigitalPaymentActive &&
                                              !_isWalletActive) {
                                            showCustomSnackBar(
                                                'no_payment_method_is_enabled'
                                                    .tr);
                                          } else if (_orderAmount <
                                              _restaurant.minimumOrder) {
                                            showCustomSnackBar(
                                                '${'minimum_order_amount_is'.tr} ${_restaurant.minimumOrder}');
                                          } else if ((orderController
                                                          .selectedDateSlot ==
                                                      0 &&
                                                  _todayClosed) ||
                                              (orderController
                                                          .selectedDateSlot ==
                                                      1 &&
                                                  _tomorrowClosed)) {
                                            showCustomSnackBar(
                                                'restaurant_is_closed'.tr);
                                          } else if (orderController
                                                      .timeSlots ==
                                                  null ||
                                              orderController
                                                      .timeSlots.length ==
                                                  0) {
                                            if (_restaurant.scheduleOrder) {
                                              showCustomSnackBar(
                                                  'select_a_time'.tr);
                                            } else {
                                              showCustomSnackBar(
                                                  'restaurant_is_closed'.tr);
                                            }
                                          } else if (!_isAvailable) {
                                            showCustomSnackBar(
                                                'one_or_more_products_are_not_available_for_this_selected_time'
                                                    .tr);
                                          } else if (orderController
                                                      .orderType !=
                                                  'take_away' &&
                                              orderController.distance == -1 &&
                                              _deliveryCharge == -1) {
                                            showCustomSnackBar(
                                                'delivery_fee_not_set_yet'.tr);
                                          } else if (orderController
                                                      .paymentMethodIndex ==
                                                  2 &&
                                              Get.find<UserController>()
                                                      .userInfoModel !=
                                                  null &&
                                              Get.find<UserController>()
                                                      .userInfoModel
                                                      .walletBalance <
                                                  _total) {
                                            showCustomSnackBar(
                                                'you_do_not_have_sufficient_balance_in_wallet'
                                                    .tr);
                                          } else {
                                            List<Cart> carts = [];
                                            for (int index = 0;
                                                index < _cartList.length;
                                                index++) {
                                              CartModel cart = _cartList[index];
                                              List<int> _addOnIdList = [];
                                              List<int> _addOnQtyList = [];
                                              cart.addOnIds.forEach((addOn) {
                                                _addOnIdList.add(addOn.id);
                                                _addOnQtyList
                                                    .add(addOn.quantity);
                                              });
                                              carts.add(
                                                Cart(
                                                  cart.isCampaign
                                                      ? null
                                                      : cart.product.id,
                                                  cart.isCampaign
                                                      ? cart.product.id
                                                      : null,
                                                  cart.discountedPrice
                                                      .toString(),
                                                  '',
                                                  cart.variation,
                                                  cart.quantity,
                                                  _addOnIdList,
                                                  cart.addOns,
                                                  _addOnQtyList,
                                                ),
                                              );
                                            }
                                            print(
                                                '=== paymentStatus: ${orderController.paymentMethodIndex == 0 ? 'cash_on_delivery' : orderController.paymentMethodIndex == 1 ? 'digital_payment' : orderController.paymentMethodIndex == 2 ? 'wallet' : 'digital_payment'}');
                                            AddressModel _address =
                                                locationController
                                                            .addressIndex ==
                                                        -1
                                                    ? Get.find<
                                                            LocationController>()
                                                        .getUserAddress()
                                                    : locationController
                                                            .addressList[
                                                        locationController
                                                            .addressIndex];
                                            orderController.placeOrder(
                                              PlaceOrderBody(
                                                cart: carts,
                                                couponDiscountAmount:
                                                    Get.find<CouponController>()
                                                        .discount,
                                                distance:
                                                    orderController.distance,
                                                couponDiscountTitle:
                                                    Get.find<CouponController>()
                                                                .discount >
                                                            0
                                                        ? Get.find<
                                                                CouponController>()
                                                            .coupon
                                                            .title
                                                        : null,
                                                scheduleAt: !_restaurant
                                                        .scheduleOrder
                                                    ? null
                                                    : (orderController
                                                                    .selectedDateSlot ==
                                                                0 &&
                                                            orderController
                                                                    .selectedTimeSlot ==
                                                                0)
                                                        ? null
                                                        : DateConverter
                                                            .dateToDateAndTime(
                                                                _scheduleStartDate),
                                                orderAmount: _total,
                                                orderNote: _noteController.text,
                                                orderType:
                                                    orderController.orderType,
                                                paymentMethod: orderController
                                                            .paymentMethodIndex ==
                                                        0
                                                    ? 'cash_on_delivery'
                                                    : orderController
                                                                .paymentMethodIndex ==
                                                            1
                                                        ? 'digital_payment'
                                                        : orderController
                                                                    .paymentMethodIndex ==
                                                                2
                                                            ? 'wallet'
                                                            : 'digital_payment',
                                                couponCode: (Get.find<
                                                                    CouponController>()
                                                                .discount >
                                                            0 ||
                                                        (Get.find<CouponController>()
                                                                    .coupon !=
                                                                null &&
                                                            Get.find<
                                                                    CouponController>()
                                                                .freeDelivery))
                                                    ? Get.find<
                                                            CouponController>()
                                                        .coupon
                                                        .code
                                                    : null,
                                                restaurantId: _cartList[0]
                                                    .product
                                                    .restaurantId,
                                                latitude: _address.latitude,
                                                longitude: _address.longitude,
                                                addressType:
                                                    _address.addressType,
                                                contactPersonName: _address
                                                        .contactPersonName ??
                                                    '${Get.find<UserController>().userInfoModel.fName} '
                                                        '${Get.find<UserController>().userInfoModel.lName}',
                                                contactPersonNumber: _address
                                                        .contactPersonNumber ??
                                                    Get.find<UserController>()
                                                        .userInfoModel
                                                        .phone,
                                                discountAmount: 0,
                                                totalTaxAmount: _totalTaxAmount,
                                                address: _address.address,
                                                house: _address.house,
                                                road: _address.road,
                                                floor: _address.floor.trim(),
                                                dmTips:
                                                    _tipController.text.trim(),
                                                promo: 0,
                                                serviceCharge: 0,
                                                serverTip: 0,
                                              ),
                                              _callback,
                                              _total,
                                              _address.companyName,
                                              _address.villageName,
                                              _address.aptNumber,
                                            );
                                          }
                                        })
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator());
                  });
                });
              });
            })
          : NotLoggedInScreen(),
    );
  }

  void _callback(
    bool isSuccess,
    String message,
    String orderID,
    double amount,
  ) async {
    if (isSuccess) {
      if (widget.fromCart) {
        Get.find<CartController>().clearCartList();
      }
      Get.find<OrderController>().stopLoader();
      if (Get.find<OrderController>().paymentMethodIndex == 0 ||
          Get.find<OrderController>().paymentMethodIndex == 2) {
        Get.offNamed(
          RouteHelper.getOrderSuccessRoute(orderID, 'success', amount),
        );
      } else {
        if (GetPlatform.isWeb) {
          Get.back();
          String hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl =
              '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&customer_id=${Get.find<UserController>().userInfoModel.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&amount=$amount&status=';
          html.window.open(selectedUrl, "_self");
        } else {
          Get.offNamed(
            RouteHelper.getPaymentRoute(
              orderID,
              Get.find<UserController>().userInfoModel.id,
              amount,
            ),
          );
        }
      }
      Get.find<OrderController>().clearPrevData();
      Get.find<OrderController>().updateTips(-1);
      Get.find<CouponController>().removeCouponData(false);
    } else {
      showCustomSnackBar(message);
    }
  }
}
