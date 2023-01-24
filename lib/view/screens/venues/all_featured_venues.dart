import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/topBarContainer.dart';
import 'package:efood_multivendor/view/base/venues_featured_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/featured_rentals_logo_widge.dart';
import 'package:efood_multivendor/view/screens/home/widget/main_commission_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllFeaturedVenuesScreen extends StatefulWidget {
  const AllFeaturedVenuesScreen({Key key}) : super(key: key);

  @override
  State<AllFeaturedVenuesScreen> createState() =>
      _AllFeaturedVenuesScreenState();
}

class _AllFeaturedVenuesScreenState extends State<AllFeaturedVenuesScreen> {
  List<Restaurant> restRestaurants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RestaurantController>(builder: (restaurantController) {
        restRestaurants = [];
        if (restaurantController.restaurantModel != null &&
            restaurantController.restaurantModel.restaurants.isNotEmpty) {
          restaurantController.restaurantModel.restaurants.forEach((element) {
            if (element.featured == 1) {
              restRestaurants.add(element.copyWith());
            }
          });
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              TopBarContainer(
                title: 'Featured Venues'.tr,
                fromNav: false,
                onCLickBack: () {
                  Get.back();
                },
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (restRestaurants.length > 0)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    for (int index = 0;
                                        index < restRestaurants.length;
                                        index++)
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            Dimensions.HEIGHT_OF_CHEF_CELL + 48,
                                        child: Center(
                                          child: VenuesFeaturedWidget(
                                            restaurant: restRestaurants[index],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.94,
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
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
                      if (restRestaurants.isEmpty)
                        NoDataScreen(
                          text: 'No Featured Venues'.tr,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
