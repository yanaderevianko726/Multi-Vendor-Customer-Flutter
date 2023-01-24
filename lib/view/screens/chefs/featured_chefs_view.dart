import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/featured_chefs_widget.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedChefsView extends StatefulWidget {
  final int cuisineIndex;
  const FeaturedChefsView({
    Key key,
    this.cuisineIndex,
  }) : super(key: key);

  @override
  State<FeaturedChefsView> createState() => _FeaturedChefsViewState();
}

class _FeaturedChefsViewState extends State<FeaturedChefsView> {
  List<Restaurant> featuredRestaurants = [];
  List<Vendor> vendors = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return GetBuilder<VendorController>(builder: (vendorController) {
        featuredRestaurants = [];
        vendors = [];
        int _cuisineId = 0;
        if (widget.cuisineIndex > 0) {
          _cuisineId = Get.find<CuisineController>()
              .cuisinesList[widget.cuisineIndex - 1]
              .id;
        }
        if (restaurantController.restaurantModel != null &&
            restaurantController.restaurantModel.restaurants.isNotEmpty) {
          if (vendorController.featuredVendorList != null &&
              vendorController.featuredVendorList.isNotEmpty) {
            vendorController.featuredVendorList.forEach((vendor) {
              var restIndex =
                  restaurantController.restaurantModel.restaurants.indexWhere(
                (restaurantTmp) => restaurantTmp.vendorId == vendor.id,
              );
              if (restIndex != -1) {
                if (widget.cuisineIndex == 0) {
                  featuredRestaurants.add(restaurantController
                      .restaurantModel.restaurants[restIndex]
                      .copyWith());
                  vendors.add(vendor);
                } else {
                  if (_cuisineId ==
                      restaurantController
                          .restaurantModel.restaurants[restIndex].cuisineId) {
                    featuredRestaurants.add(restaurantController
                        .restaurantModel.restaurants[restIndex]
                        .copyWith());
                    vendors.add(vendor);
                  }
                }
              }
            });
          }
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2,
              ),
              featuredRestaurants.isNotEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 2),
                          child: TitleWidget(
                            title: 'Featured Chefs'.tr,
                            onTap: () {
                              Get.toNamed(
                                RouteHelper.getFeaturedChefsAll(),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: FeaturedChefsWidget(
                            featuredVendors: vendors,
                            restaurants: featuredRestaurants,
                            noDataText: 'no_wish_data_found'.tr,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        );
      });
    });
  }
}
