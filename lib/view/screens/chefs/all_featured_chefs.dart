import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/cuisine_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/view/base/featured_chef_widget.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/topBarContainer.dart';
import 'package:efood_multivendor/view/screens/chefs/chef_cuisine_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllFeaturedChefs extends StatefulWidget {
  const AllFeaturedChefs({Key key}) : super(key: key);

  @override
  State<AllFeaturedChefs> createState() => _AllFeaturedChefsState();
}

class _AllFeaturedChefsState extends State<AllFeaturedChefs> {
  List<Restaurant> restaurants = [];
  List<Vendor> vendors = [];
  int offset = 1, cuisineIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(builder: (cuisineController) {
      return GetBuilder<RestaurantController>(builder: (restaurantController) {
        return GetBuilder<VendorController>(builder: (vendorController) {
          List<CuisineModel> _cuisines = [];
          _cuisines.add(
            CuisineModel(),
          );

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

          restaurants = [];
          vendors = [];

          if (vendorController.allVendorList != null &&
              vendorController.allVendorList.isNotEmpty) {
            vendorController.allVendorList.forEach((vendor) {
              if (vendor.vFeatured == 1) {
                if (cuisineIndex > 0) {
                  if (vendor.cuisineId == cuisineId) {
                    vendors.add(vendor);
                  }
                } else {
                  vendors.add(vendor);
                }
              }
            });
            if (vendors.length > 0) {
              if (restaurantController.restaurantModel != null &&
                  restaurantController.restaurantModel.restaurants.isNotEmpty) {
                vendors.forEach((vendor) {
                  var restIndex = restaurantController
                      .restaurantModel.restaurants
                      .indexWhere(
                    (restaurantTmp) => restaurantTmp.vendorId == vendor.id,
                  );
                  if (restIndex != -1) {
                    restaurants.add(restaurantController
                        .restaurantModel.restaurants[restIndex]
                        .copyWith());
                  }
                });
              }
            }
          }
          double listWidth = MediaQuery.of(context).size.width * 0.96;
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  TopBarContainer(
                    title: 'Featured Chefs'.tr,
                    fromNav: false,
                    onCLickBack: () {
                      Get.back();
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
                    child: Stack(
                      children: [
                        if (restaurants.isNotEmpty)
                          Container(
                            width: listWidth,
                            child: ListView.builder(
                              key: UniqueKey(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: false,
                              padding: EdgeInsets.all(2),
                              itemCount: restaurants.length,
                              itemBuilder: (context, index) {
                                return FeaturedChefWidget(
                                  vendor: vendors[index],
                                  restaurant: restaurants[index],
                                  index: index,
                                  length: restaurants.length,
                                  isCampaign: false,
                                  inRestaurant: false,
                                  cellWidth: listWidth,
                                );
                              },
                            ),
                          ),
                        if (vendors.isEmpty &&
                            vendorController.featuredVendorList.isEmpty)
                          NoDataScreen(
                            text: 'No Any Chefs'.tr,
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      });
    });
  }
}
