import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/topBarContainer.dart';
import 'package:efood_multivendor/view/screens/restaurant/all_venues.dart';
import 'package:efood_multivendor/view/screens/restaurant/featured_venues.dart';
import 'package:efood_multivendor/view/screens/restaurant/new_venues.dart';
import 'package:efood_multivendor/view/screens/restaurant/trending_venues.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenuesScreen extends StatefulWidget {
  final bool fromNav;
  final Function openDrawer;
  const VenuesScreen({
    Key key,
    this.fromNav = false,
    this.openDrawer,
  }) : super(key: key);

  static Future<void> getVenuesList(bool reload, {int offset = 1}) async {
    await Get.find<RestaurantController>().getRestaurantList(reload, offset: 1);
  }

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Restaurant> restRestaurants = [];
  int offset = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            TopBarContainer(
              title: 'venues'.tr,
              fromNav: widget.fromNav,
              onCLickBack: () {
                Get.back();
              },
              openDrawer: () {
                widget.openDrawer();
              },
            ),
            SizedBox(
              height: 5,
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
                  fontSize: Dimensions.fontSizeSmall,
                ),
                labelStyle: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).primaryColor,
                ),
                tabs: [
                  Tab(text: 'All Venues'.tr),
                  Tab(text: 'Featured'.tr),
                  Tab(text: 'Trending'.tr),
                  Tab(text: 'New'.tr),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  AllVenuesScreen(),
                  FeaturedVenuesScreen(),
                  TrendingVenuesScreen(),
                  NewVenuesScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
