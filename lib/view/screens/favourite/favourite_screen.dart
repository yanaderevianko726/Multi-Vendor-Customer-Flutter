import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/base/topBarContainer.dart';
import 'package:efood_multivendor/view/screens/favourite/widget/fav_chefs.dart';
import 'package:efood_multivendor/view/screens/favourite/widget/fav_foods_screen.dart';
import 'package:efood_multivendor/view/screens/favourite/widget/fav_venues.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  final bool fromNav;
  final Function openDrawer;
  const FavouriteScreen({
    Key key,
    this.fromNav = false,
    this.openDrawer,
  }) : super(key: key);
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Future<void> initPageData() async {
    await Get.find<WishListController>().getWishList();
    await Get.find<ProductController>().getPopularProductList(false, 'all');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    initPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Get.find<AuthController>().isLoggedIn()
          ? Column(
              children: [
                TopBarContainer(
                  title: 'favorite'.tr,
                  fromNav: widget.fromNav,
                  onCLickBack: () {
                    Get.back();
                  },
                  openDrawer: () {
                    widget.openDrawer();
                  },
                ),
                SizedBox(
                  height: Dimensions.PADDING_SIZE_SMALL,
                ),
                Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  height: 48,
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
                      color: Theme.of(context).primaryColor,
                    ),
                    tabs: [
                      Tab(text: 'chefs'.tr),
                      Tab(text: 'venues'.tr),
                      Tab(text: 'foods'.tr),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FavChefView(index: 0),
                      FavVenues(index: 1),
                      FavFoodsScreen(index: 3),
                    ],
                  ),
                ),
              ],
            )
          : NotLoggedInScreen(),
    );
  }
}
