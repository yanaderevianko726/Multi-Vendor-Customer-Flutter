import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/reservations/tabs/reservation_detail.dart';
import 'package:efood_multivendor/view/screens/review/rate_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackReservationScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsModel;
  const TrackReservationScreen({
    Key key,
    this.orderDetailsModel,
  }) : super(key: key);
  @override
  State<TrackReservationScreen> createState() => _TrackReservationScreenState();
}

class _TrackReservationScreenState extends State<TrackReservationScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double dotLineWidth = 54;
    double titleWidth = 64;
    double titleSpaceWidth = 20;

    int reserveStatus = 0;
    return GetBuilder<ReservationController>(builder: (reservationController) {
      if (reservationController.trackReservation != null) {
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
      var trackStatusStr = '';
      if(reserveStatus == 0){
        trackStatusStr = 'Please pay for this reservation.';
      }else if(reserveStatus == 1){
        trackStatusStr = 'Your reservation is in pending now, we will check it and accept it soon, please keep track status.';
      }else if(reserveStatus == 2){
        trackStatusStr = 'Your reservation accepted and it is preparing now, this reservation can be ready soon, please keep track status.';
      }else if(reserveStatus == 3){
        trackStatusStr = 'Your reservation is ready now, please take food.';
      }else if(reserveStatus == 3){
        trackStatusStr = 'Your reservation completed.';
      }
      return Scaffold(
        appBar: CustomAppBar(
            title: 'Track Reservation'.tr,
            onBackPressed: () {
              Get.back();
            }),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: titleWidth,
                        height: 30,
                        child: Center(
                          child: Text(
                            '${'Choose'.tr}',
                            style: robotoMedium.copyWith(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: titleSpaceWidth,
                      ),
                      Container(
                        width: titleWidth,
                        height: 30,
                        child: Center(
                          child: Text(
                            '${'Confirm & Pay'.tr}',
                            style: robotoMedium.copyWith(
                              fontSize: 12,
                              color: reserveStatus == 0
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: titleSpaceWidth,
                      ),
                      Container(
                        width: titleWidth,
                        height: 30,
                        child: Center(
                          child: Text(
                            '${'Preparing'.tr}',
                            style: robotoMedium.copyWith(
                              fontSize: 12,
                              color: reserveStatus >= 2
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: titleSpaceWidth,
                      ),
                      Container(
                        width: titleWidth,
                        height: 30,
                        child: Center(
                          child: Text(
                            '${'Recipe'.tr}',
                            style: robotoMedium.copyWith(
                              fontSize: 12,
                              color: reserveStatus >= 3
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '1',
                            style: robotoMedium.copyWith(
                              fontSize: 16,
                              color: greenDark,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: dotLineWidth,
                        child: DottedLine(
                          dashColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                            width: 1,
                            color: reserveStatus == 0
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '2',
                            style: robotoMedium.copyWith(
                              fontSize: 16,
                              color: reserveStatus == 0
                                  ? Theme.of(context).disabledColor
                                  : greenDark,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: dotLineWidth,
                        child: DottedLine(
                          dashColor: reserveStatus == 0
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                            width: 1,
                            color: reserveStatus >= 2
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '3',
                            style: robotoMedium.copyWith(
                              fontSize: 16,
                              color: reserveStatus >= 2
                                  ? greenDark
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: dotLineWidth,
                        child: DottedLine(
                          dashColor: reserveStatus >= 2
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                            width: 1,
                            color: reserveStatus >= 3
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '4',
                            style: robotoMedium.copyWith(
                              fontSize: 16,
                              color: reserveStatus >= 3
                                  ? greenDark
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 80,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/image/ic_reserve_track.png',
                            width: 180,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            top: 8,
                            right: 8,
                          ),
                          child: Text(
                            '${reservationController.trackReservation.orderName}',
                            style: robotoMedium.copyWith(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      left: 24,
                      top: 44,
                      right: 24,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '$trackStatusStr',
                            style: robotoRegular.copyWith(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: 100,
                            height: 56,
                            child: CustomButton(
                              buttonText: 'Refresh'.tr,
                              margin: EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                Get.find<ReservationController>()
                                    .getReservationInfo(
                                        '${reservationController.trackReservation.id}')
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  if (reserveStatus == 0)
                    Container(
                      child: Center(
                        child: CustomButton(
                          buttonText: 'Confirm & Pay'.tr,
                          margin: EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          onPressed: () {
                            confirmAndPay();
                          },
                        ),
                      ),
                    ),
                  if (reserveStatus >= 1 && reserveStatus < 3)
                    Container(
                      child: Center(
                        child: CustomButton(
                          buttonText: 'Back to Details'.tr,
                          margin: EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  if (reserveStatus == 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomButton(
                        buttonText: 'Recipe'.tr,
                        onPressed: () {
                          Get.bottomSheet(
                            confirmRecipeSheet(
                              context,
                              onClickYes: () {
                                Get.back();
                                finishReservation();
                              },
                            ),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: false,
                          );
                        },
                      ),
                    ),
                  if (reserveStatus == 4)
                    Container(
                      child: Center(
                        child: CustomButton(
                          buttonText: 'Review'.tr,
                          margin: EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL,
                          ),
                          onPressed: () {
                            gotoReviewProducts();
                          },
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 28,
                  ),
                ],
              ),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      );
    });
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

  void finishReservation() {
    setState(() {
      _isLoading = true;
    });
    Get.find<OrderController>()
        .completeOrder(
      Get.find<ReservationController>().trackReservation.orderId,
      Get.find<ReservationController>().trackReservation.id,
    )
        .then((value) {
      if (value.isSuccess) {
        Get.find<ReservationController>().getReservationList(false).then((value) async {
          await Get.find<OrderController>().getReserveOrders(1).then((value){
            updateTableSchedule();
          });
        });
      } else {
        showCustomSnackBar(
          'Fail to complete this order, please try again.',
          isError: false,
        );
        setState(() {
          _isLoading = false;
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
        _isLoading = true;
      });
      Get.find<ReservationController>()
          .getReservationInfo(
          '${Get.find<ReservationController>().trackReservation.id}')
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  Future<void> gotoReviewProducts() async {
    setState(() {
      _isLoading = false;
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
}
