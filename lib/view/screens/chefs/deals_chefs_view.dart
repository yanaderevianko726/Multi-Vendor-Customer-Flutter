import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/chefs_another_widget.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealsChefsView extends StatefulWidget {
  final int cuisineIndex;
  const DealsChefsView({
    Key key,
    this.cuisineIndex,
  }) : super(key: key);

  @override
  State<DealsChefsView> createState() => _DealsChefsViewState();
}

class _DealsChefsViewState extends State<DealsChefsView> {
  List<Restaurant> restaurants = [];
  List<Vendor> vendors = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return GetBuilder<VendorController>(builder: (vendorController) {
        restaurants = [];
        vendors = [];

        int _cuisineId = 0;
        if (widget.cuisineIndex > 0) {
          _cuisineId = Get.find<CuisineController>()
              .cuisinesList[widget.cuisineIndex - 1]
              .id;
        }

        if (restaurantController.restaurantModel != null &&
            restaurantController.restaurantModel.restaurants.isNotEmpty) {
          vendorController.allVendorList.forEach((vendor) {
            if (vendor.vFeatured != 1) {
              var restIndex =
                  restaurantController.restaurantModel.restaurants.indexWhere(
                (restaurantTmp) => restaurantTmp.vendorId == vendor.id,
              );
              if (restIndex != -1) {
                if (widget.cuisineIndex == 0) {
                  restaurants.add(restaurantController
                      .restaurantModel.restaurants[restIndex]
                      .copyWith());
                  vendors.add(vendor);
                } else {
                  if (_cuisineId ==
                      restaurantController
                          .restaurantModel.restaurants[restIndex].cuisineId) {
                    restaurants.add(restaurantController
                        .restaurantModel.restaurants[restIndex]
                        .copyWith());
                    vendors.add(vendor);
                  }
                }
              }
            }
          });
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2,
              ),
              restaurants.isNotEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 2),
                          child: TitleWidget(
                            title: 'Meal Deals'.tr,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: Dimensions.HEIGHT_OF_CHEF_CELL + 48,
                          child: ListView.builder(
                            key: UniqueKey(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: vendors.length,
                            itemBuilder: (context, index) {
                              return ChefsAnotherWidget(
                                vendor: vendors[0],
                                inRestaurant: false,
                                length: vendors.length,
                                restaurants: restaurants,
                                style: 1,
                              );
                            },
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
