import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({
    Key key,
  }) : super(key: key);
  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return GetBuilder<OrderController>(
      builder: (orderController) {
        List<OrderModel> orderList = [];
        bool paginate = false;
        int pageSize = 1;
        int offset = 1;
        if (orderController.deliveryHistoryOrderList != null) {
          orderList = orderController.deliveryHistoryOrderList;
          paginate = orderController.historyPaginate;
          pageSize = (orderController.historyPageSize / 10).ceil();
          offset = orderController.deliveryHistoryOffset;
        }
        scrollController.addListener(() {
          if (scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent &&
              orderList != null &&
              !paginate) {
            if (offset < pageSize) {
              Get.find<OrderController>().setOffset(offset + 1, false);
              print('end of the page');
              Get.find<OrderController>().showBottomLoader(false);
              Get.find<OrderController>().getDeliveryHistoryOrders(offset + 1);
            }
          }
        });

        return orderList != null
            ? orderList.length > 0
                ? RefreshIndicator(
                    onRefresh: () async {
                      await orderController.getDeliveryHistoryOrders(1);
                    },
                    child: Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Ongoing Order'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          for (var index = 0; index < orderList.length; index++)
                            InkWell(
                              onTap: () {
                                Get.toNamed(
                                  RouteHelper.getOrderDetailsRoute(
                                      orderList[index].id),
                                  arguments: OrderDetailsScreen(
                                    orderId: orderList[index].id,
                                    orderModel: orderList[index],
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(
                                  12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .grey[Get.isDarkMode ? 700 : 300],
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (await canLaunchUrlString(
                                            'tel:${orderList[index].restaurant.phone}')) {
                                          launchUrlString(
                                              'tel:${orderList[index].restaurant.phone}',
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          showCustomSnackBar(
                                              '${'can_not_launch'.tr} ${orderList[index].restaurant.phone}');
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Image.asset(
                                                'assets/image/ic_phone_green.png',
                                                width: 16,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              '${orderList[index].restaurant.phone}',
                                              style: robotoRegular.copyWith(
                                                fontSize: 15,
                                                color: blueDark,
                                              ),
                                              maxLines: 1,
                                            ),
                                            Spacer(),
                                            SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: Image.asset(
                                                'assets/image/message.png',
                                                width: 20,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: DottedLine(
                                        dashColor:
                                            Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL,
                                            ),
                                            child: CustomImage(
                                              image:
                                                  '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}'
                                                  '/${orderList[index].restaurant != null ? orderList[index].restaurant.logo : ''}',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.21,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.21,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${orderList[index].deliveryAddress.contactPersonName}',
                                                  style: robotoMedium.copyWith(
                                                    fontSize: 15,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  'Driver pick up chefs food',
                                                  style: robotoRegular.copyWith(
                                                    fontSize: 12,
                                                    color: orderList[index]
                                                                .pickedUp ==
                                                            null
                                                        ? Theme.of(context)
                                                            .disabledColor
                                                        : yellowLight,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/image/ic_clock.png',
                                                      width: 12,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    SizedBox(
                                                      width: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL,
                                                    ),
                                                    Text(
                                                      '${orderList[index].restaurant.deliveryTime} ${'min food will arrive'.tr}',
                                                      style:
                                                          robotoMedium.copyWith(
                                                        fontSize: 12,
                                                        color: yellowLight,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${orderList[index].detailsCount} ${orderList[index].detailsCount > 1 ? 'items'.tr : 'item'.tr}',
                                                      style: robotoRegular
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeExtraSmall,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 18,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                        vertical: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          Dimensions
                                                              .RADIUS_SMALL,
                                                        ),
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      child: Text(
                                                        orderList[index]
                                                            .orderStatus
                                                            .tr,
                                                        style: robotoMedium
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 25,
                                      padding: const EdgeInsets.all(12),
                                      child: DottedLine(
                                        dashColor:
                                            Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${'order_id'.tr}:',
                                            style: robotoMedium.copyWith(
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            '#${orderList[index].id}',
                                            style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '\$${double.parse((orderList[index].orderAmount).toStringAsFixed(2))}',
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
                            )
                        ],
                      ),
                    ),
                  )
                : SizedBox()
            : SizedBox();
      },
    );
  }
}
