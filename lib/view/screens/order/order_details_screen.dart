import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_product_widget.dart';
import 'package:efood_multivendor/view/screens/review/rate_review_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  OrderDetailsScreen({
    @required this.orderModel,
    @required this.orderId,
  });
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  StreamSubscription _stream;

  void _loadData(BuildContext context, bool reload) async {
    await Get.find<OrderController>().trackOrder(
      widget.orderId.toString(),
      reload ? null : widget.orderModel,
      false,
    );
    if (widget.orderModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    Get.find<OrderController>().getOrderDetails(widget.orderId.toString());
  }

  @override
  void initState() {
    super.initState();

    _stream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage on Details: ${message.data}");
      _loadData(context, true);
    });
    _loadData(context, false);
  }

  @override
  void dispose() {
    super.dispose();
    _stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.orderModel == null) {
          return Get.offAllNamed(
            RouteHelper.getInitialRoute(),
          );
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'order_details'.tr,
            onBackPressed: () {
              if (widget.orderModel == null) {
                Get.offAllNamed(RouteHelper.getInitialRoute());
              } else {
                Get.back();
              }
            }),
        body: GetBuilder<OrderController>(builder: (orderController) {
          double _deliveryCharge = 0;
          double _itemsPrice = 0;
          double _discount = 0;
          double _couponDiscount = 0;
          double _tax = 0;
          double _addOns = 0;
          double _dmTips = 0;
          OrderModel _order = orderController.trackModel;
          print('=== _order.orderType: ${_order.orderType}');

          if (orderController.orderDetails != null) {
            if (_order.orderType == 'delivery') {
              _deliveryCharge = _order.deliveryCharge;
              _dmTips = _order.dmTips;
            }
            _couponDiscount = _order.couponDiscountAmount;
            _discount = _order.restaurantDiscountAmount;
            _tax = _order.totalTaxAmount;
            for (OrderDetailsModel orderDetails
                in orderController.orderDetails) {
              for (AddOn addOn in orderDetails.addOns) {
                _addOns = _addOns + (addOn.price * addOn.quantity);
              }
              _itemsPrice =
                  _itemsPrice + (orderDetails.price * orderDetails.quantity);
            }
          }
          double _subTotal = _itemsPrice + _addOns;
          double _total = _itemsPrice +
              _addOns -
              _discount +
              _tax +
              _deliveryCharge -
              _couponDiscount +
              _dmTips;

          return orderController.orderDetails != null
              ? Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              ),
                              Text(
                                'restaurant_details'.tr,
                                style: robotoRegular,
                              ),
                              SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              ),
                              _order.restaurant != null
                                  ? Row(children: [
                                      ClipOval(
                                        child: CustomImage(
                                          image:
                                              '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${_order.restaurant.logo}',
                                          height: 35,
                                          width: 35,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimensions.PADDING_SIZE_SMALL,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _order.restaurant.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                              ),
                                            ),
                                            Text(
                                              _order.restaurant.address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      (_order.orderType == 'take_away' &&
                                              (_order.orderStatus ==
                                                      'pending' ||
                                                  _order.orderStatus ==
                                                      'accepted' ||
                                                  _order.orderStatus ==
                                                      'confirmed' ||
                                                  _order.orderStatus ==
                                                      'processing' ||
                                                  _order.orderStatus ==
                                                      'handover' ||
                                                  _order.orderStatus ==
                                                      'picked_up'))
                                          ? TextButton.icon(
                                              onPressed: () async {
                                                String url =
                                                    'https://www.google.com/maps/dir/?api=1&destination=${_order.restaurant.latitude}'
                                                    ',${_order.restaurant.longitude}&mode=d';
                                                if (await canLaunchUrlString(
                                                    url)) {
                                                  await launchUrlString(url,
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                } else {
                                                  showCustomSnackBar(
                                                      'unable_to_launch_google_map'
                                                          .tr);
                                                }
                                              },
                                              icon: Icon(Icons.directions),
                                              label: Text('direction'.tr),
                                            )
                                          : SizedBox(),
                                    ])
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_SMALL,
                                        ),
                                        child: Text(
                                          'no_restaurant_data_found'.tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 32,
                              ),

                              Row(
                                children: [
                                  Text(
                                    '${'Order Number'.tr}:',
                                    style: robotoMedium,
                                  ),
                                  Spacer(),
                                  Text(
                                    _order.id.toString(),
                                    style: robotoMedium.copyWith(
                                      color: yellowDark,
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                  top: 12,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ),

                              Row(
                                children: [
                                  Text(
                                    '${'Order Placed on'.tr}:',
                                    style: robotoMedium,
                                  ),
                                  Spacer(),
                                  Text(
                                    DateConverter.dateTimeStringToDateTime(
                                      _order.createdAt,
                                    ),
                                    style: robotoRegular,
                                  ),
                                ],
                              ),

                              _order.scheduled == 1
                                  ? Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                            top: 12,
                                          ),
                                          child: DottedLine(
                                            dashColor:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        Row(children: [
                                          Text('${'scheduled_at'.tr}:',
                                              style: robotoMedium),
                                          Spacer(),
                                          Text(
                                            DateConverter
                                                .dateTimeStringToDateTime(
                                                    _order.scheduleAt),
                                            style: robotoRegular,
                                          ),
                                        ]),
                                      ],
                                    )
                                  : SizedBox(),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                  top: 12,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ),

                              Row(children: [
                                Text(
                                  '${'Order Type'.tr}: ',
                                  style: robotoMedium,
                                ),
                                Spacer(),
                                Text(
                                  _order.orderType.tr,
                                  style: robotoRegular,
                                ),
                              ]),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                  top: 12,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ),

                              Row(children: [
                                Text(
                                  '${'Payment Method'.tr}:',
                                  style: robotoMedium,
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL,
                                    ),
                                  ),
                                  child: Text(
                                    _order.paymentMethod == 'cash_on_delivery'
                                        ? 'cash_on_delivery'.tr
                                        : _order.paymentMethod == 'wallet'
                                            ? 'wallet_payment'.tr
                                            : 'digital_payment'.tr,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context).cardColor,
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                    ),
                                  ),
                                ),
                              ]),

                              Get.find<SplashController>()
                                      .configModel
                                      .orderDeliveryVerification
                                  ? Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                            bottom: 18,
                                            top: 12,
                                          ),
                                          child: DottedLine(
                                            dashColor:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${'delivery_verification_code'.tr}:',
                                              style: robotoMedium,
                                            ),
                                            Spacer(),
                                            Text(
                                              _order.otp,
                                              style: robotoRegular,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : SizedBox(),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                  top: 12,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ),

                              Row(
                                children: [
                                  Text(
                                    'Instructions'.tr,
                                    style: robotoMedium,
                                  ),
                                  Spacer(),
                                  (_order.orderNote == null ||
                                          _order.orderNote.isEmpty)
                                      ? Text(
                                          'None'.tr,
                                          style: robotoRegular,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              (_order.orderNote != null &&
                                      _order.orderNote.isNotEmpty)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: Dimensions.WEB_MAX_WIDTH,
                                            padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL,
                                              ),
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                            child: Text(
                                              _order.orderNote,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE,
                                          ),
                                        ])
                                  : SizedBox(),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                  top: 12,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ), //

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                child: Row(children: [
                                  Text(
                                    '${'Items'.tr}:',
                                    style: robotoMedium,
                                  ),
                                  SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                  Text(
                                    orderController.orderDetails.length
                                        .toString(),
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Container(
                                      height: 7,
                                      width: 7,
                                      decoration: BoxDecoration(
                                        color:
                                            (_order.orderStatus == 'failed' ||
                                                    _order.orderStatus ==
                                                        'refunded')
                                                ? Colors.red
                                                : Colors.green,
                                        shape: BoxShape.circle,
                                      )),
                                  SizedBox(
                                      width:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    _order.orderStatus == 'delivered'
                                        ? '${'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(_order.delivered)}'
                                        : _order.orderStatus.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ]),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 14,
                                  top: 8,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderController.orderDetails.length,
                                itemBuilder: (context, index) {
                                  return OrderProductWidget(
                                    order: _order,
                                    orderDetails:
                                        orderController.orderDetails[index],
                                  );
                                },
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Items Price'.tr,
                                    style: robotoMedium,
                                  ),
                                  Text(
                                    PriceConverter.convertPrice(
                                      _itemsPrice,
                                    ),
                                    style: robotoRegular,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'addons'.tr,
                                      style: robotoMedium,
                                    ),
                                    Text(
                                      '(+) ${PriceConverter.convertPrice(_addOns)}',
                                      style: robotoRegular,
                                    ),
                                  ]),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  top: 12,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ), //

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'subtotal'.tr,
                                      style: robotoMedium,
                                    ),
                                    Text(
                                      PriceConverter.convertPrice(_subTotal),
                                      style: robotoMedium,
                                    ),
                                  ]),
                              SizedBox(height: 22),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'discount'.tr,
                                      style: robotoMedium,
                                    ),
                                    Text(
                                      '(-) ${PriceConverter.convertPrice(_discount)}',
                                      style: robotoRegular,
                                    ),
                                  ]),
                              SizedBox(
                                height: 10,
                              ),

                              _couponDiscount > 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          Text(
                                            'coupon_discount'.tr,
                                            style: robotoRegular,
                                          ),
                                          Text(
                                            '(-) ${PriceConverter.convertPrice(_couponDiscount)}',
                                            style: robotoRegular,
                                          ),
                                        ])
                                  : SizedBox(),
                              SizedBox(height: _couponDiscount > 0 ? 12 : 0),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('vat_tax'.tr, style: robotoMedium),
                                    Text(
                                      '(+) ${PriceConverter.convertPrice(_tax)}',
                                      style: robotoRegular,
                                    ),
                                  ]),

                              SizedBox(
                                height: 12,
                              ),

                              (_order.orderType != 'take_away' &&
                                      Get.find<SplashController>()
                                              .configModel
                                              .dmTipsStatus ==
                                          1)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('delivery_man_tips'.tr,
                                            style: robotoMedium),
                                        Text(
                                          '(+) ${PriceConverter.convertPrice(_dmTips)}',
                                          style: robotoRegular,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                  height: (_order.orderType != 'take_away' &&
                                          Get.find<SplashController>()
                                                  .configModel
                                                  .dmTipsStatus ==
                                              1)
                                      ? 12
                                      : 0),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('delivery_fee'.tr,
                                        style: robotoMedium),
                                    _deliveryCharge > 0
                                        ? Text(
                                            '(+) ${PriceConverter.convertPrice(_deliveryCharge)}',
                                            style: robotoRegular,
                                          )
                                        : Text(
                                            'free'.tr,
                                            style: robotoRegular.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                  ]),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  bottom: 18,
                                  top: 12,
                                ),
                                child: DottedLine(
                                  dashColor: Theme.of(context).disabledColor,
                                ),
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'total_amount'.tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Text(
                                      PriceConverter.convertPrice(_total),
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  !orderController.showCancelled
                      ? Center(
                          child: SizedBox(
                            width: Dimensions.WEB_MAX_WIDTH + 20,
                            child: Row(children: [
                              (_order.orderStatus == 'pending' ||
                                      _order.orderStatus == 'accepted' ||
                                      _order.orderStatus == 'confirmed' ||
                                      _order.orderStatus == 'processing' ||
                                      _order.orderStatus == 'handover' ||
                                      _order.orderStatus == 'picked_up')
                                  ? Expanded(
                                      child: CustomButton(
                                        buttonText: 'track_order'.tr,
                                        margin: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL,
                                        ),
                                        onPressed: () {
                                          Get.toNamed(
                                            RouteHelper.getOrderTrackingRoute(
                                              _order.id,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                              _order.orderStatus == 'pending'
                                  ? Expanded(
                                      child: Padding(
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            minimumSize: Size(1, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            )),
                                        onPressed: () {
                                          Get.dialog(ConfirmationDialog(
                                            icon: Images.warning,
                                            description:
                                                'are_you_sure_to_cancel'.tr,
                                            onYesPressed: () {
                                              orderController
                                                  .cancelOrder(_order.id);
                                            },
                                          ));
                                        },
                                        child: Text('cancel_order'.tr,
                                            style: robotoBold.copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                            )),
                                      ),
                                    ))
                                  : SizedBox(),
                            ]),
                          ),
                        )
                      : Center(
                          child: Container(
                            width: Dimensions.WEB_MAX_WIDTH,
                            height: 50,
                            margin: EdgeInsets.all(
                              Dimensions.PADDING_SIZE_SMALL,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimensions.RADIUS_SMALL,
                              ),
                            ),
                            child: Text(
                              'order_cancelled'.tr,
                              style: robotoMedium.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                  (_order.orderStatus == 'delivered' &&
                          orderController.orderDetails[0].itemCampaignId ==
                              null)
                      ? Center(
                          child: Container(
                            width: Dimensions.WEB_MAX_WIDTH,
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: CustomButton(
                              buttonText: 'review'.tr,
                              onPressed: () {
                                List<OrderDetailsModel> _orderDetailsList = [];
                                List<int> _orderDetailsIdList = [];
                                orderController.orderDetails
                                    .forEach((orderDetail) {
                                  if (!_orderDetailsIdList
                                      .contains(orderDetail.foodDetails.id)) {
                                    _orderDetailsList.add(orderDetail);
                                    _orderDetailsIdList
                                        .add(orderDetail.foodDetails.id);
                                  }
                                });
                                Get.toNamed(
                                  RouteHelper.getReviewRoute(),
                                  arguments: RateReviewScreen(
                                    orderDetailsList: _orderDetailsList,
                                    deliveryMan: _order.deliveryMan,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                  (_order.orderStatus == 'failed' &&
                          Get.find<SplashController>()
                              .configModel
                              .cashOnDelivery)
                      ? Center(
                          child: Container(
                            width: Dimensions.WEB_MAX_WIDTH,
                            padding: EdgeInsets.all(
                              Dimensions.PADDING_SIZE_SMALL,
                            ),
                            child: CustomButton(
                              buttonText: 'switch_to_cash_on_delivery'.tr,
                              onPressed: () {
                                Get.dialog(
                                  ConfirmationDialog(
                                      icon: Images.warning,
                                      description: 'are_you_sure_to_switch'.tr,
                                      onYesPressed: () {
                                        orderController
                                            .switchToCOD(
                                          _order.id.toString(),
                                        )
                                            .then((isSuccess) {
                                          Get.back();
                                          if (isSuccess) {
                                            Get.back();
                                          }
                                        });
                                      }),
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                ])
              : Center(
                  child: CircularProgressIndicator(),
                );
        }),
      ),
    );
  }
}
