import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/reservations/reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_screen.dart';

class OrdersMainScreen extends StatefulWidget {
  final Function openDrawer;
  const OrdersMainScreen({
    Key key,
    this.openDrawer,
  }) : super(key: key);
  @override
  State<OrdersMainScreen> createState() => _OrdersMainScreenState();
}

class _OrdersMainScreenState extends State<OrdersMainScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).viewPadding.top + 60,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 200],
                        spreadRadius: 1,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.openDrawer != null) widget.openDrawer();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.menu,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'orders'.tr,
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: InkWell(
                          onTap: () => Get.toNamed(
                            RouteHelper.getCartRoute(),
                          ),
                          child: Badge(
                            badgeContent: Text(
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
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.PADDING_SIZE_SMALL,
                ),
                Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  height: 46,
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
                      Tab(text: 'orders'.tr),
                      Tab(text: 'reservations_title'.tr),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      OrderScreen(),
                      ReservationScreen(fromNav: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
