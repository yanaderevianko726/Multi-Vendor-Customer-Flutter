import 'dart:async';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/featured_venue_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/sharedpref_util.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/drawer_widget.dart';
import 'package:efood_multivendor/view/base/main_floating_widget.dart';
import 'package:efood_multivendor/view/screens/chefs/chefs_screen.dart';
import 'package:efood_multivendor/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:efood_multivendor/view/screens/home/home_screen.dart';
import 'package:efood_multivendor/view/screens/order/orders_main.dart';
import 'package:efood_multivendor/view/screens/swushd_premium/swushd_venues_screen.dart';
import 'package:efood_multivendor/view/screens/venues/venues_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({
    @required this.pageIndex,
  });

  static Future<void> loadData(bool reload, int _offset, int limit) async {
    await Get.find<RestaurantController>()
        .getRestaurantList(reload, offset: _offset, limit: limit);
    await Get.find<CuisineController>().getCuisinesList(true);
    await Get.find<CategoryController>().getCategoryList(reload);
    await Get.find<BannerController>().getBannerList(reload);
    await Get.find<VendorController>().getVendorList(reload);
    await Get.find<ProductController>().getPopularProductList(true, 'all');

    await Get.find<FeaturedVenueController>().getFeaturedVenueList(reload);
  }

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget> _screens;
  PageController _pageController;
  int _pageIndex = 2, _drawerIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> initDashboard() async {
    if (Get.find<AuthController>().isLoggedIn()) {
      var deviceId = await PlatformDeviceId.getDeviceId;
      if (Get.find<UserController>().userInfoModel != null) {
        Get.find<UserController>().userInfoModel.deviceId = deviceId;
      }
    }
    Get.find<LocationController>().getAddressList();
    Get.find<ReservationController>().getReservationList(false);
    Get.find<OrderController>().getReserveOrders(1);
    await Get.find<WishListController>().getWishList();

    await DashboardScreen.loadData(false, 1, 10);
  }

  @override
  void initState() {
    super.initState();
    SharedPrefUtil().init();

    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _pageIndex);

    _screens = [
      VenuesScreen(
        fromNav: true,
        openDrawer: () {
          if (mounted) {
            openDrawer();
          }
        },
      ),
      ChefsScreen(
        fromNav: true,
        openDrawer: () {
          if (mounted) {
            openDrawer();
          }
        },
      ),
      HomeScreen(
        openDrawer: () {
          if (mounted) {
            openDrawer();
          }
        },
      ),
      SwushdVenuesScreen(
        fromNav: true,
        openDrawer: () {
          if (mounted) {
            openDrawer();
          }
        },
      ),
      OrdersMainScreen(
        openDrawer: () {
          if (mounted) {
            openDrawer();
          }
        },
      ),
    ];

    Future.delayed(Duration.zero, () async {
      initDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerWidget(
          index: _drawerIndex,
          onClickDrawerItem: (clickIndex) {
            _onClickDrawerItems(clickIndex);
          },
        ),
      ),
      floatingActionButton: ResponsiveHelper.isDesktop(context)
          ? null
          : FloatingActionButton(
              elevation: 5,
              backgroundColor: _pageIndex == 2
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              onPressed: () => _setPage(2),
              child: MainFloatingWidget(
                color: _pageIndex == 2
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                isSelected: _pageIndex == 2,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ResponsiveHelper.isDesktop(context)
          ? SizedBox()
          : BottomAppBar(
              elevation: 5,
              notchMargin: 5,
              clipBehavior: Clip.antiAlias,
              shape: CircularNotchedRectangle(),
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 64,
                      height: 58,
                      margin: EdgeInsets.only(left: 6),
                      child: BottomNavItem(
                        assetData: _pageIndex == 0
                            ? 'assets/image/ic_venue_red.png'
                            : 'assets/image/ic_venue_grey.png',
                        title: 'Restaurants'.tr,
                        isSelected: _pageIndex == 0,
                        iconSize: 20,
                        onTap: () => _setPage(0),
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 58,
                      child: BottomNavItem(
                        assetData: _pageIndex == 1
                            ? 'assets/image/ic_chef_red.png'
                            : 'assets/image/ic_chef_grey.png',
                        title: 'Chefs'.tr,
                        isSelected: _pageIndex == 1,
                        iconSize: 18,
                        fontSize: 11,
                        onTap: () => _setPage(1),
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 58,
                    ),
                    Container(
                      width: 64,
                      height: 58,
                      child: BottomNavItem(
                        assetData: _pageIndex == 3
                            ? 'assets/image/ic_award.png'
                            : 'assets/image/ic_award_grey.png',
                        title: '${'SWUSHD Venues'.tr}',
                        isSelected: _pageIndex == 3,
                        iconSize: 21,
                        onTap: () => _setPage(3),
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 58,
                      margin: EdgeInsets.only(right: 6),
                      child: BottomNavItem(
                        assetData: _pageIndex == 4
                            ? 'assets/image/ic_order.png'
                            : 'assets/image/ic_order_grey.png',
                        title: 'orders'.tr,
                        isSelected: _pageIndex == 4,
                        iconSize: 18,
                        onTap: () => _setPage(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _screens.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _screens[index];
        },
      ),
    );
  }

  void openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
      _pageController.jumpToPage(pageIndex);
    });
  }

  void _onClickDrawerItems(int clickIndex) {
    Get.back();
    setState(() {
      if (clickIndex != 7) {
        _drawerIndex = clickIndex;
      }
    });
    if (clickIndex == 0) {
      print('=== clickIndex: $clickIndex');
      Get.toNamed(RouteHelper.getProfileRoute());
    } else if (clickIndex == 1) {
      Get.toNamed(RouteHelper.getFavoritesRoute(''));
    } else if (clickIndex == 2) {
      Get.toNamed(RouteHelper.getReservations('fromNav'));
    } else if (clickIndex == 4) {
      Get.toNamed(RouteHelper.getLanguageRoute(''));
    } else if (clickIndex == 5) {
      Get.toNamed(RouteHelper.getSupportRoute());
    } else if (clickIndex == 6) {
      Get.toNamed(RouteHelper.getReferAndEarnRoute());
    } else if (clickIndex == 7) {
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.dialog(
          ConfirmationDialog(
            icon: Images.support,
            description: 'are_you_sure_to_logout'.tr,
            isLogOut: true,
            onYesPressed: () {
              Get.find<AuthController>().clearSharedData();
              Get.find<CartController>().clearCartList();
              Get.find<WishListController>().removeWishes();
              Get.offAllNamed(
                RouteHelper.getSignInRootRoute(),
              );
            },
          ),
          useSafeArea: false,
        );
      } else {
        Get.find<WishListController>().removeWishes();
        Get.toNamed(
          RouteHelper.getSignInRoute(RouteHelper.main),
        );
      }
    }
  }
}
