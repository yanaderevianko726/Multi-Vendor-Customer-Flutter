import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tabs/reservation_detail.dart';
import 'tabs/reserve_food_detail.dart';

class ReserveDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  ReserveDetailsScreen({
    this.orderModel,
  });
  @override
  _ReserveDetailsScreenState createState() => _ReserveDetailsScreenState();
}

class _ReserveDetailsScreenState extends State<ReserveDetailsScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  void _loadData(BuildContext context, bool reload) async {
    await Get.find<SplashController>().getConfigData();
    Get.find<OrderController>().getOrderDetails(
      widget.orderModel.id.toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _loadData(context, false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Reservation Details'.tr,
          onBackPressed: () {
            Get.back();
          }),
      body: GetBuilder<OrderController>(
        builder: (orderController) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  height: 46,
                  margin: EdgeInsets.only(top: 8),
                  color: Theme.of(context).cardColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: robotoRegular.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.fontSizeSmall),
                    labelStyle: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).primaryColor),
                    tabs: [
                      Tab(text: 'Reservation'.tr),
                      Tab(text: 'Foods'.tr),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ReservationTapPage(
                        orderModel: widget.orderModel,
                        orderDetailsModel: orderController.orderDetails,
                      ),
                      ReserveFoodsPage(
                        orderModel: widget.orderModel,
                        orderDetailsModel: orderController.orderDetails,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
