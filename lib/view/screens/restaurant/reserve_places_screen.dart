import 'package:dotted_border/dotted_border.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/data/model/response/reservation_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/reservations/reservation_details_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/running_reserve_place_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'make_reserve_a_place.dart';
import 'widget/history_reserve_place_view.dart';

class ReservePlacesScreen extends StatefulWidget {
  final Restaurant restaurant;

  const ReservePlacesScreen({
    Key key,
    this.restaurant,
  }) : super(key: key);

  @override
  State<ReservePlacesScreen> createState() => _ReservePlacesScreenState();
}

class _ReservePlacesScreenState extends State<ReservePlacesScreen> {
  Future<void> initReservations() async {
    Get.find<ReservationController>().getReservationList(false);
    Get.find<OrderController>().getReserveOrders(1);
  }

  @override
  void initState() {
    super.initState();
    initReservations();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReservationController>(
      builder: (reservationController) {
        List<ReservationModel> runningReserves = [];
        List<ReservationModel> finishedReserves = [];
        var creatable = false;
        if (reservationController.placeReserveRunningList != null &&
            reservationController.placeReserveRunningList.isNotEmpty) {
          reservationController.placeReserveRunningList.forEach((reserve) {
            if (reserve.venueId == widget.restaurant.id) {
              runningReserves.add(reserve);
            }
          });
        }
        if (runningReserves.isNotEmpty) {
          creatable = false;
        } else {
          creatable = true;
        }
        if (reservationController.placeReserveHistoryList != null &&
            reservationController.placeReserveHistoryList.isNotEmpty) {
          reservationController.placeReserveHistoryList.forEach((reserve) {
            if (reserve.venueId == widget.restaurant.id) {
              finishedReserves.add(reserve);
            }
          });
        }

        return GetBuilder<CartController>(builder: (cartController) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${'Reserve A Place'.tr}',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Theme.of(context).textTheme.bodyText1.color,
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
              actions: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: InkWell(
                        onTap: () => Get.toNamed(
                          RouteHelper.getReserveCart(),
                        ),
                        child: Badge(
                          label: Text(
                            '${cartController.cartList != null && cartController.cartList.isNotEmpty ? cartController.cartList.length : 0}',
                            style: robotoRegular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          child: Image.asset(
                            'assets/image/ic_cart.png',
                            width: 22,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(16),
              child: RefreshIndicator(
                onRefresh: () async {
                  initReservations();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (creatable)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 8),
                          child: Center(
                            child: DottedBorder(
                              color: yellowLight,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: [8, 5],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    RouteHelper.getReserveAPlace(),
                                    arguments: MakeReserveAPlaceScreen(
                                      restaurant: widget.restaurant,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.88,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Create New'.tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: 18,
                                        color: yellowLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!creatable)
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                'Ongoing Place Reservations'.tr,
                                style: robotoMedium.copyWith(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            for (int i = 0; i < runningReserves.length; i++)
                              RunningReservePlaceWidget(
                                reservationModel: runningReserves[i],
                                cellIndex: i,
                                onClickCell: (cellIndex) {
                                  print('=== cellIndex: $cellIndex');
                                  reservationController.setTrackReservation(
                                      runningReserves[cellIndex]);
                                  if (Get.find<OrderController>()
                                              .reserveOrderList !=
                                          null &&
                                      Get.find<OrderController>()
                                              .reserveOrderList
                                              .length >
                                          0) {
                                    var orderInd = Get.find<OrderController>()
                                        .reserveOrderList
                                        .indexWhere((element) =>
                                            element.id ==
                                            runningReserves[cellIndex].orderId);
                                    if (orderInd != -1) {
                                      Get.toNamed(
                                        RouteHelper.getReserveDetailsRoute(
                                          runningReserves[cellIndex].orderId,
                                        ),
                                        arguments: ReserveDetailsScreen(
                                          orderModel:
                                              Get.find<OrderController>()
                                                  .reserveOrderList[orderInd],
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                          ],
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      if (finishedReserves.isNotEmpty)
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                'History Place Reservations'.tr,
                                style: robotoMedium.copyWith(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            for (int i = 0; i < finishedReserves.length; i++)
                              HistoryReservePlaceWidget(
                                reservationModel: finishedReserves[i],
                                cellIndex: i,
                                onClickCell: (cellIndex) {
                                  print('=== cellIndex: $cellIndex');
                                  reservationController.setTrackReservation(
                                      finishedReserves[cellIndex]);
                                  if (Get.find<OrderController>()
                                              .reserveOrderList !=
                                          null &&
                                      Get.find<OrderController>()
                                              .reserveOrderList
                                              .length >
                                          0) {
                                    var orderInd = Get.find<OrderController>()
                                        .reserveOrderList
                                        .indexWhere((element) =>
                                            element.id ==
                                            finishedReserves[cellIndex]
                                                .orderId);
                                    if (orderInd != -1) {
                                      Get.toNamed(
                                        RouteHelper.getReserveDetailsRoute(
                                          finishedReserves[cellIndex].orderId,
                                        ),
                                        arguments: ReserveDetailsScreen(
                                          orderModel:
                                              Get.find<OrderController>()
                                                  .reserveOrderList[orderInd],
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
