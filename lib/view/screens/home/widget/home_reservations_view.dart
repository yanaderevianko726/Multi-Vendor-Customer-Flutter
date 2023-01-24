import 'package:dotted_border/dotted_border.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/reservation_details_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/widgets/completed_reservation_widget.dart';
import 'package:efood_multivendor/view/screens/reservations/widgets/running_reserve_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeReservationsView extends StatefulWidget {
  const HomeReservationsView({Key key}) : super(key: key);
  @override
  _HomeReservationsViewState createState() => _HomeReservationsViewState();
}

class _HomeReservationsViewState extends State<HomeReservationsView> {
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
    return GetBuilder<CartController>(builder: (cartyController) {
      return GetBuilder<ReservationController>(
          builder: (reservationController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.PADDING_SIZE_LARGE,
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DottedBorder(
                    color: yellowLight,
                    strokeWidth: 1,
                    strokeCap: StrokeCap.butt,
                    dashPattern: [8, 5],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(8),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          RouteHelper.getMakeReservation(),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.RADIUS_SMALL,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Reserve A Table'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: 18,
                              color: yellowLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (reservationController.runningReserveList != null &&
                      reservationController.runningReserveList.isNotEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        left: 18,
                        top: 22,
                        right: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ongoing Reservation'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          for (int i = 0;
                              i <
                                  reservationController
                                      .runningReserveList.length;
                              i++)
                            RunningReservationWidget(
                              reservationModel:
                                  reservationController.runningReserveList[i],
                              cellIndex: i,
                              onClickCell: (cellIndex) {
                                reservationController.setTrackReservation(
                                    reservationController
                                        .runningReserveList[cellIndex]);
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
                                          reservationController
                                              .runningReserveList[cellIndex]
                                              .orderId);
                                  if (orderInd != -1) {
                                    Get.toNamed(
                                      RouteHelper.getReserveDetailsRoute(
                                        reservationController
                                            .runningReserveList[cellIndex]
                                            .orderId,
                                      ),
                                      arguments: ReserveDetailsScreen(
                                        orderModel: Get.find<OrderController>()
                                            .reserveOrderList[orderInd],
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  if (reservationController.historyReserveList != null &&
                      reservationController.historyReserveList.isNotEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        left: 18,
                        top: 22,
                        right: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Histories of Reservation'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: 17,
                            ),
                          ),
                          for (int i = 0;
                              i <
                                  reservationController
                                      .historyReserveList.length;
                              i++)
                            CompletedReservationWidget(
                              reservationModel:
                                  reservationController.historyReserveList[i],
                              cellIndex: i,
                              onClickCell: (cellIndex) {
                                reservationController.setTrackReservation(
                                    reservationController
                                        .historyReserveList[cellIndex]);
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
                                          reservationController
                                              .historyReserveList[cellIndex]
                                              .orderId);
                                  if (orderInd != -1) {
                                    Get.toNamed(
                                      RouteHelper.getReserveDetailsRoute(
                                        reservationController
                                            .historyReserveList[cellIndex]
                                            .orderId,
                                      ),
                                      arguments: ReserveDetailsScreen(
                                        orderModel: Get.find<OrderController>()
                                            .reserveOrderList[orderInd],
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  if (reservationController.runningReserveList.isEmpty &&
                      reservationController.historyReserveList.isEmpty)
                    NoDataScreen(
                      text: 'No any Reservations'.tr,
                    ),
                ],
              ),
            ),
          ],
        );
      });
    });
  }
}
