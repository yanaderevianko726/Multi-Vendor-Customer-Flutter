import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/chefs_another_widget.dart';
import 'package:efood_multivendor/view/base/featured_chefs_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavChefView extends StatefulWidget {
  final int index;
  const FavChefView({Key key, this.index}) : super(key: key);

  static Future<void> getVendorsList(bool reload) async {
    await Get.find<VendorController>().getVendorList(reload);
  }

  @override
  State<FavChefView> createState() => _FavChefViewState();
}

class _FavChefViewState extends State<FavChefView> {
  List<Vendor> featuredFavVendors = [];
  List<Restaurant> featuredFavRestaurants = [];
  List<Vendor> favoriteVendors = [];
  List<Restaurant> favRestaurants = [];

  Future<void> initData() async {
    await Get.find<WishListController>().getWishList();
  }

  @override
  void initState() {
    super.initState();
    // initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RestaurantController>(builder: (restaurantController) {
        return GetBuilder<WishListController>(builder: (wishController) {
          featuredFavVendors = [];
          featuredFavRestaurants = [];
          favoriteVendors = [];
          favRestaurants = [];

          if (wishController.wishVendorsList != null &&
              wishController.wishVendorsList.isNotEmpty) {
            if (restaurantController.restaurantModel != null &&
                restaurantController.restaurantModel.restaurants.isNotEmpty) {
              wishController.wishVendorsList.forEach((vendor) {
                var restIndex = restaurantController.restaurantModel.restaurants
                    .indexWhere(
                        (restaurantTmp) => restaurantTmp.vendorId == vendor.id);
                if (restIndex != -1) {
                  if (vendor.vFeatured == 1) {
                    featuredFavRestaurants.add(restaurantController
                        .restaurantModel.restaurants[restIndex]);
                    featuredFavVendors.add(vendor);
                  } else {
                    favRestaurants.add(restaurantController
                        .restaurantModel.restaurants[restIndex]);
                    favoriteVendors.add(vendor);
                  }
                }
              });
            }
          }
          return RefreshIndicator(
            onRefresh: () async {
              await Get.find<WishListController>().getWishList();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (featuredFavVendors.length > 0)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 2,
                          ),
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Text(
                                  'featured_chefs'.tr,
                                  style: robotoMedium.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: FeaturedChefsWidget(
                                  featuredVendors: featuredFavVendors,
                                  restaurants: featuredFavRestaurants,
                                  noDataText: 'no_wish_data_found'.tr,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  favoriteVendors.length > 0
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          color: Theme.of(context).cardColor,
                          child: Column(
                            children: [
                              SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10, top: 4),
                                child: Text(
                                  'Favorite Chefs'.tr,
                                  style: robotoMedium.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              for (int index = 0;
                                  index < favoriteVendors.length;
                                  index++)
                                ChefsAnotherWidget(
                                  vendor: favoriteVendors[index],
                                  restaurants: favRestaurants,
                                  length: favoriteVendors.length,
                                )
                            ],
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
