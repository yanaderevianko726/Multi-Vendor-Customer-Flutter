import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/cuisine_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/view/base/topBarContainer.dart';
import 'package:efood_multivendor/view/screens/chefs/deals_chefs_view.dart';
import 'package:efood_multivendor/view/screens/chefs/featured_chefs_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/featured_rentals_logo_widge.dart';
import 'package:efood_multivendor/view/screens/home/widget/main_commission_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chef_cuisine_view.dart';

class ChefsScreen extends StatefulWidget {
  final bool fromNav;
  final Function openDrawer;
  const ChefsScreen({
    Key key,
    this.fromNav = false,
    this.openDrawer,
  }) : super(key: key);

  static Future<void> getChefsList(bool reload, {int offset = 1}) async {
    await Get.find<VendorController>().getVendorList(reload);
  }

  @override
  State<ChefsScreen> createState() => _ChefsScreenState();
}

class _ChefsScreenState extends State<ChefsScreen> {
  List<Restaurant> restRestaurants = [];
  List<Vendor> vendors = [];
  List<Vendor> featuredVendors = [];
  int offset = 1, cuisineIndex = 0;

  Future<void> getVendorsList() async {
    await ChefsScreen.getChefsList(false, offset: offset);
  }

  @override
  void initState() {
    super.initState();
    getVendorsList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        body: GetBuilder<CuisineController>(builder: (cuisineController) {
          return GetBuilder<RestaurantController>(
              builder: (restaurantController) {
            return GetBuilder<VendorController>(builder: (vendorController) {
              List<CuisineModel> _cuisines = [];
              _cuisines.add(CuisineModel());

              int cuisineId;
              if (cuisineController.cuisinesList != null &&
                  cuisineController.cuisinesList.isNotEmpty) {
                cuisineController.cuisinesList.forEach((element) {
                  _cuisines.add(element);
                });
              }
              if (cuisineIndex == 0) {
                cuisineId = 0;
              } else {
                cuisineId = _cuisines[cuisineIndex].id;
              }

              restRestaurants = [];
              vendors = [];
              if (vendorController.anotherVendorList != null &&
                  vendorController.anotherVendorList.isNotEmpty) {
                vendorController.anotherVendorList.forEach((vendor) {
                  if (cuisineIndex > 0) {
                    if (vendor.cuisineId == cuisineId) {
                      vendors.add(vendor);
                    }
                  } else {
                    vendors.add(vendor);
                  }
                });
                if (vendors.length > 0) {
                  if (restaurantController.restaurantModel != null &&
                      restaurantController
                          .restaurantModel.restaurants.isNotEmpty) {
                    vendors.forEach((vendor) {
                      var restIndex = restaurantController
                          .restaurantModel.restaurants
                          .indexWhere(
                        (restaurantTmp) => restaurantTmp.vendorId == vendor.id,
                      );
                      if (restIndex != -1) {
                        restRestaurants.add(restaurantController
                            .restaurantModel.restaurants[restIndex]
                            .copyWith());
                      }
                    });
                  }
                }
              }
              return Column(
                children: [
                  TopBarContainer(
                    title: 'chefs'.tr,
                    fromNav: widget.fromNav,
                    onCLickBack: () {
                      Get.back();
                    },
                    openDrawer: () {
                      widget.openDrawer();
                    },
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  ChefCuisineView(
                    cuisineIndex: cuisineIndex,
                    cuisines: _cuisines,
                    onClickCuisine: (idx) {
                      setState(() {
                        cuisineIndex = idx;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await ChefsScreen.getChefsList(
                          false,
                          offset: offset,
                        );
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FeaturedChefsView(
                              cuisineIndex: cuisineIndex,
                            ),
                            DealsChefsView(
                              cuisineIndex: cuisineIndex,
                            ),
                            FeaturedRentalsLogoWidge(),
                            SizedBox(
                              height: 8,
                            ),
                            MainCommissionWidget(),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            });
          });
        }),
      ),
    );
  }
}
