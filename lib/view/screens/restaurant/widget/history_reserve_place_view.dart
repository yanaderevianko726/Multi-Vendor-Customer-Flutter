import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/data/model/response/reservation_model.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HistoryReservePlaceWidget extends StatelessWidget {
  final ReservationModel reservationModel;
  final int cellIndex;
  final Function onClickCell;
  const HistoryReservePlaceWidget({
    Key key,
    this.reservationModel,
    this.onClickCell,
    this.cellIndex,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var strStatus = reservationModel.reserveStatus == 0 ? 'Pending' : reservationModel.reserveStatus == 1 ? 'Preparing' : reservationModel.reserveStatus == 2 ? 'Ready' : reservationModel.reserveStatus == 3 ? 'Completed' : '';
    var statusAsset = reservationModel.reserveStatus == 0 ? 'assets/image/ic_delivery_pending.png' : reservationModel.reserveStatus == 1 ? 'assets/image/ic_delivery_pickup.png' : reservationModel.reserveStatus == 2 ? 'assets/image/ic_delivery_missed.png' : reservationModel.reserveStatus == 3 ? 'assets/image/ic_delivery_success.png' : '';
    return InkWell(
      onTap: () {
        onClickCell(cellIndex);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
            12,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[Get.isDarkMode ? 700 : 300],
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Place Name'.tr,
                  style: robotoMedium.copyWith(
                    fontSize: 15,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Spacer(),
                Image.asset('$statusAsset', width: 16, fit: BoxFit.fitHeight,),
                SizedBox(width: 6,),
                Text(
                  '$strStatus',
                  style: robotoRegular.copyWith(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 4,
              ),
              child: Text(
                '${reservationModel.tableName}',
                style: robotoMedium.copyWith(
                  fontSize: 17,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${'Order ID'.tr}: ',
                        style: robotoMedium.copyWith(
                          fontSize: 15,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      Text(
                        '#${reservationModel.orderId} ',
                        style: robotoRegular.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: reservationModel.paymentStatus == 'paid' ? 54 : 70,
                  height: 22,
                  child: Container(
                    decoration: BoxDecoration(
                      color: reservationModel.paymentStatus == 'paid'
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${reservationModel.paymentStatus == 'paid' ? 'PAID' :'UNPAID'}',
                        style: robotoRegular.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            DottedLine(
              dashColor: Theme.of(context).disabledColor,
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(
                    '${reservationModel.venueName}',
                    style: robotoMedium.copyWith(
                      fontSize: 15,
                    ),
                    maxLines: 1,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunchUrlString(
                              'tel:${reservationModel.chefPhone}')) {
                            launchUrlString('tel:${reservationModel.chefPhone}',
                                mode: LaunchMode.externalApplication);
                          } else {
                            showCustomSnackBar(
                                '${'can_not_launch'.tr} ${reservationModel.chefPhone}');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2.0),
                                child: Image.asset(
                                  'assets/image/ic_phone_green.png',
                                  width: 16,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${reservationModel.chefPhone}',
                                style: robotoMedium.copyWith(
                                  fontSize: 14,
                                  color: blueDark,
                                  decoration: TextDecoration.underline,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 56,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'View'.tr,
                          style: robotoMedium.copyWith(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${'Reserved for'.tr} ${reservationModel.numberInParty} ${'guests'.tr}',
                        style: robotoMedium.copyWith(
                          fontSize: 15,
                          color: yellowLight,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 25,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: DottedLine(
                dashColor: Theme.of(context).disabledColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Row(
                children: [
                  Text(
                    '${reservationModel.reserveDate}, ${reservationModel.startTime}',
                    style: robotoRegular.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    maxLines: 1,
                  ),
                  Spacer(),
                  Text(
                    '\$${double.parse((reservationModel.price).toStringAsFixed(2))}',
                    style: robotoMedium.copyWith(
                      fontSize: 15,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
