import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_history_view.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_running_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    Key key,
  }) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoggedIn;

  void initLoad() {
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      Get.find<OrderController>().getDeliveryRunningOrders(1);
      Get.find<OrderController>().getDeliveryHistoryOrders(1);
    }
  }

  @override
  void initState() {
    super.initState();
    initLoad();
  }

  @override
  Widget build(BuildContext context) {
    int orderCount = 0;
    if (Get.find<OrderController>().deliveryRunningOrderList != null &&
        Get.find<OrderController>().deliveryRunningOrderList.isNotEmpty) {
      if (Get.find<OrderController>().deliveryHistoryOrderList != null &&
          Get.find<OrderController>().deliveryHistoryOrderList.isNotEmpty) {
        orderCount = 1;
      }
    }
    return Scaffold(
      body: _isLoggedIn
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    OrderRunningView(),
                    OrderHistoryView(),
                    if (orderCount == 0)
                      NoDataScreen(
                        text: 'No any Orders'.tr,
                      ),
                  ],
                ),
              ),
            )
          : NotLoggedInScreen(),
    );
  }
}
