import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/reservations/widgets/track_reservation_screen.dart';
import 'package:efood_multivendor/view/screens/review/rate_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReservationTapPage extends StatefulWidget {
  final OrderModel orderModel;
  final List<OrderDetailsModel> orderDetailsModel;
  const ReservationTapPage({
    Key key,
    this.orderDetailsModel,
    this.orderModel,
  }) : super(key: key);
  @override
  State<ReservationTapPage> createState() => _ReservationTapPageState();
}

class _ReservationTapPageState extends State<ReservationTapPage> {
  OrderModel _order;
  int reserveStatus = 0;
  var isLoading = false;
  var cardType = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _order = widget.orderModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    BaseUrls baseUrls = Get.find<SplashController>().configModel.baseUrls;
    return GetBuilder<ReservationController>(builder: (reservationController) {
      return GetBuilder<OrderController>(builder: (orderController) {
        double _itemsPrice = 0;
        double _addOns = 0;
        double _tax = _order.restaurant.tax;
        double _serviceCharge = _order.restaurant.serviceCharge;
        double _serverTip = _order.restaurant.serverTip;
        double _promo = _order.restaurant.promo;
        int _serverTipMethod = _order.serverTipMethod;

        double _taxAmount = 0.0;
        double _serviceChargeAmount = 0.0;
        double _promoAmount = 0.0;
        double _serverTipAmount = 0;


        var reserveType = '';
        int __type = 0;
        if (reservationController.trackReservation != null) {
          __type = reservationController.trackReservation.reserveType;
          reserveType = __type == 0 ? 'Reservation' : __type == 1 ? 'Reserve A Place' : __type == 2 ? 'Pick-Up' : 'Dine-In';
          if (reservationController.trackReservation.paymentStatus == 'paid') {
            reserveStatus = 1;
            if (reservationController.trackReservation.reserveStatus == 1) {
              reserveStatus = 2; // accepted and processing
            } else if (reservationController.trackReservation.reserveStatus ==
                2) {
              reserveStatus = 3; // ready to serve
            } else if (reservationController.trackReservation.reserveStatus ==
                3) {
              reserveStatus = 4; // complete
            }
          }
        }

        if (_order != null) {
          if (widget.orderDetailsModel != null) {
            for (OrderDetailsModel orderDetails in widget.orderDetailsModel) {
              for (AddOn addOn in orderDetails.addOns) {
                _addOns = _addOns + (addOn.price * addOn.quantity);
              }
              _itemsPrice =
                  _itemsPrice + (orderDetails.price * orderDetails.quantity);
            }
          }
        }

        double _subTotal = _itemsPrice + _addOns;

        if (_tax > 0) {
          _taxAmount = (_subTotal * _tax) / 100;
        }
        if (_serviceCharge > 0) {
          _serviceChargeAmount = (_subTotal * _serviceCharge) / 100;
        }
        if (_promo > 0) {
          _promoAmount = (_subTotal * _promo) / 100;
        }
        if (_serverTip > 0) {
          if (_serverTipMethod == 1) {
            _serverTipAmount = (_subTotal * _serverTip) / 100;
          } else if (_serverTipMethod == 2) {
            _serverTipAmount = _serverTip;
          }
        }

        double _total = _subTotal +
            _taxAmount +
            _serviceChargeAmount +
            _promoAmount +
            _serverTipAmount;

        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(12),
            child: Stack(
              children: [
                if (_order != null && widget.orderDetailsModel != null)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'restaurant_details'.tr,
                                style: robotoMedium.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 12,
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
                                      TextButton.icon(
                                        onPressed: () async {
                                          String url =
                                              'https://www.google.com/maps/dir/?api=1&destination=${_order.restaurant.latitude}'
                                              ',${_order.restaurant.longitude}&mode=d';
                                          if (await canLaunchUrlString(url)) {
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
                                      ),
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

                              Text(
                                '${__type == 0 ? 'Table Information'.tr : 'Place Information'.tr}',
                                style: robotoMedium.copyWith(
                                  fontSize: 15,
                                ),
                              ),

                              SizedBox(
                                height: 12,
                              ),

                              Row(
                                children: [
                                  SizedBox(width: 4,),
                                  Text(
                                    '${__type == 0 ? 'Table Name'.tr : 'Place Name'.tr}',
                                    style: robotoRegular.copyWith(fontSize: 13),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${reservationController.trackReservation.tableName}',
                                    style: robotoMedium.copyWith(
                                      fontSize: 15,
                                      color: yellowDark,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),

                              SizedBox(
                                height: 12,
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(__type == 0)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL,
                                    ),
                                    child: CustomImage(
                                      image: '${baseUrls.tablesImageUrl}'
                                          '/${reservationController.trackReservation.tableImage}',
                                      width: 85,
                                      height: 88,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if(__type == 0)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${'Start Time'.tr}: ',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                              Spacer(),
                                              Text(
                                                '${reservationController.trackReservation.startTime} ',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(__type == 0)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${'End Time'.tr}: ',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                              Spacer(),
                                              Text(
                                                '${reservationController.trackReservation.endTime} ',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${'Reserve Date'.tr}: ',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                              Spacer(),
                                              Text(
                                                '${reservationController.trackReservation.reserveDate} ',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${'Number in Party'.tr}: ',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                              Spacer(),
                                              Text(
                                                '${reservationController.trackReservation.numberInParty} ',
                                                style: robotoMedium.copyWith(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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

                              SizedBox(
                                height: 22,
                              ),

                              Text(
                                'Order Information'.tr,
                                style: robotoMedium.copyWith(
                                  fontSize: 15,
                                ),
                              ),

                              SizedBox(
                                height: 12,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${'Order ID'.tr}:',
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
                                            bottom: 18,
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
                                            '${reservationController.trackReservation.reserveDate}: ${reservationController.trackReservation.startTime} ~ ${reservationController.trackReservation.endTime}',
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
                                        '$reserveType',
                                        style: robotoRegular.copyWith(
                                          color: yellowDark,
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

                                    Row(children: [
                                      Text(
                                        '${'Payment Status'.tr}:',
                                        style: robotoMedium,
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      SizedBox(
                                        width: reservationController.trackReservation.paymentStatus == 'paid' ? 54 : 70,
                                        height: 22,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: reservationController.trackReservation.paymentStatus == 'paid'
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${reservationController.trackReservation.paymentStatus == 'paid' ? 'PAID' :'UNPAID'}',
                                              style: robotoRegular.copyWith(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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
                                      children: [
                                        Text(
                                          'Special Notes'.tr,
                                          style: robotoMedium,
                                        ),
                                        Spacer(),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL,
                                              ),
                                            ),
                                            child: Text(
                                              '${Get.find<ReservationController>().trackReservation.specialNotes}',
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                                color:
                                                Theme.of(context).disabledColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: Dimensions.PADDING_SIZE_LARGE,
                                          ),

                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.only(
                                              bottom: 28,
                                              top: 12,
                                            ),
                                            child: DottedLine(
                                              dashColor: Theme.of(context).disabledColor,
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              ),

                              Text(
                                'Price Details',
                                style: robotoMedium.copyWith(
                                  fontSize: 15,
                                ),
                              ),

                              SizedBox(
                                height: 12,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
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
                                            '(+) \$${_subTotal.toStringAsFixed(2)}',
                                            style: robotoMedium,
                                          ),
                                        ]),

                                    SizedBox(height: 32),

                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${'Server Tip'.tr} ${_serverTipMethod == 1 ? '($_serverTip %)' : _serverTipMethod == 2 ? '(\$$_serverTip)' : ''}',
                                            style: robotoMedium,
                                          ),
                                          Text(
                                            '(+) \$${_serverTipAmount.toStringAsFixed(2)}',
                                            style: robotoRegular,
                                          ),
                                        ]),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('vat_tax'.tr, style: robotoMedium),
                                          Text(
                                            '(+) \$${_taxAmount.toStringAsFixed(2)}',
                                            style: robotoRegular,
                                          ),
                                        ]),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${'Service Charge'.tr}',
                                            style: robotoMedium,
                                          ),
                                          Text(
                                            '(+) \$${_serviceChargeAmount.toStringAsFixed(2)}',
                                            style: robotoRegular,
                                          ),
                                        ]),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${'Promo'.tr}',
                                            style: robotoMedium,
                                          ),
                                          Text(
                                            '(+) \$${_promoAmount.toStringAsFixed(2)}',
                                            style: robotoRegular,
                                          ),
                                        ]),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(
                                        bottom: 24,
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
                                          '\$${_total.toStringAsFixed(2)}',
                                          style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 32,
                              ),

                              if (reserveStatus == 0)
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(
                                      14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${'Payment Method'.tr}',
                                          style: robotoMedium,
                                        ),
                                        SizedBox(
                                          height: 18,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              cardType = 0;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Image.asset(
                                                  'packages/flutter_credit_card/icons/mastercard.png',
                                                  width: 40,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                SizedBox(
                                                  width: 28,
                                                ),
                                                Text(
                                                  '${'MasterCard'.tr}',
                                                  style: robotoMedium,
                                                ),
                                                Spacer(),
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: cardType == 0
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    margin: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: cardType == 0
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                            bottom: 18,
                                            top: 6,
                                            left: 12,
                                          ),
                                          child: DottedLine(
                                            dashColor:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              cardType = 1;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/image/img_visa.png',
                                                  width: 56,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                SizedBox(
                                                  width: 18,
                                                ),
                                                Text(
                                                  '${'VISA Card'.tr}',
                                                  style: robotoMedium,
                                                ),
                                                Spacer(),
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: cardType == 1
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    margin: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: cardType == 1
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                            bottom: 18,
                                            top: 18,
                                            left: 12,
                                          ),
                                          child: DottedLine(
                                            dashColor:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        if (reserveStatus == 0)
                          CustomButton(
                            buttonText: 'Confirm & Pay'.tr,
                            margin: EdgeInsets.only(top: 8, bottom: 16),
                            onPressed: () {
                              confirmAndPay();
                            },
                          ),
                        if (reserveStatus > 0 && reserveStatus <= 3)
                          CustomButton(
                            buttonText: 'Track Reservation'.tr,
                            onPressed: () {
                              Get.toNamed(
                                RouteHelper.getTrackReservations(),
                                arguments: TrackReservationScreen(
                                  orderDetailsModel: widget.orderDetailsModel,
                                ),
                              );
                            },
                          ),
                        // if (reserveStatus == 3)
                        //   CustomButton(
                        //     buttonText: 'Recipe'.tr,
                        //     onPressed: () {
                        //       Get.bottomSheet(
                        //         confirmRecipeSheet(
                        //           context,
                        //           onClickYes: () {
                        //             Get.back();
                        //             finishReservation();
                        //           },
                        //         ),
                        //         backgroundColor: Colors.transparent,
                        //         isScrollControlled: false,
                        //       );
                        //     },
                        //   ),
                        if (reserveStatus == 4)
                          SizedBox(
                            width: Dimensions.WEB_MAX_WIDTH + 20,
                            child: CustomButton(
                              buttonText: 'Review'.tr,
                              margin: EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL,
                              ),
                              onPressed: () {
                                gotoReviewProducts();
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                if (widget.orderDetailsModel == null || isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      });
    });
  }

  void finishReservation() {
    setState(() {
      isLoading = true;
    });
    Get.find<OrderController>()
        .completeOrder(
      Get.find<ReservationController>().trackReservation.orderId,
      Get.find<ReservationController>().trackReservation.id,
    )
        .then((value) {
      if (value.isSuccess) {
        updateTableSchedule();
      } else {
        showCustomSnackBar(
          'Fail to complete this order, please try again.',
          isError: false,
        );
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void updateTableSchedule() {
    Get.find<ReservationController>()
        .getTableList(
      '${Get.find<ReservationController>().trackReservation.venueId}',
    )
        .then((value) {
      setState(() {
        isLoading = true;
      });
      Get.find<ReservationController>()
          .getReservationInfo(
              '${Get.find<ReservationController>().trackReservation.id}')
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Future<void> gotoReviewProducts() async {
    await Get.find<ReservationController>().getReservationList(false);
    await Get.find<OrderController>().getReserveOrders(1);
    setState(() {
      isLoading = false;
    });
    List<OrderDetailsModel> _orderDetailsList = [];
    List<int> _orderDetailsIdList = [];
    widget.orderDetailsModel.forEach((orderDetail) {
      if (!_orderDetailsIdList.contains(orderDetail.foodDetails.id)) {
        _orderDetailsList.add(orderDetail);
        _orderDetailsIdList.add(orderDetail.foodDetails.id);
      }
    });
    Get.offAndToNamed(
      RouteHelper.getReviewRoute(),
      arguments: RateReviewScreen(
        orderDetailsList: _orderDetailsList,
        deliveryMan: null,
      ),
    );
  }

  void confirmAndPay() {
    Get.toNamed(
      RouteHelper.getPaymentTrackReserveRoute(
        '${Get.find<ReservationController>().trackReservation.orderId}',
        Get.find<UserController>().userInfoModel.id,
        Get.find<ReservationController>().trackReservation.price,
      ),
    );
  }
}

Widget confirmRecipeSheet(BuildContext context, {Function onClickYes}) {
  return Container(
    width: Dimensions.WEB_MAX_WIDTH,
    padding: EdgeInsets.symmetric(
      horizontal: 14,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
      color: Colors.white,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 26,
        ),
        Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Image.asset(
              'assets/image/ic_table_services.png',
              width: 22,
              fit: BoxFit.fitWidth,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              '${'Did you received food?'.tr}',
              style: robotoMedium.copyWith(
                fontSize: 16,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset(
                'assets/image/ic_close.png',
                width: 22,
                fit: BoxFit.fitWidth,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              width: 8,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${'No'.tr}',
                      style: robotoMedium.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onClickYes(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${'Yes'.tr}',
                      style: robotoMedium.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 22,
        ),
      ],
    ),
  );
}
