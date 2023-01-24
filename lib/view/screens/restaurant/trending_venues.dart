import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/venues_trending_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/featured_rentals_logo_widge.dart';
import 'package:efood_multivendor/view/screens/home/widget/main_commission_widget.dart';
import 'package:efood_multivendor/view/screens/venues/venues_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrendingVenuesScreen extends StatefulWidget {
  const TrendingVenuesScreen({Key key}) : super(key: key);
  @override
  State<TrendingVenuesScreen> createState() => _TrendingVenuesScreenState();
}

class _TrendingVenuesScreenState extends State<TrendingVenuesScreen> {
  List<Restaurant> restRestaurants = [];
  int offset = 1;

  Future<void> initData() async {
    await VenuesScreen.getVenuesList(false, offset: offset);
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RestaurantController>(builder: (restaurantController) {
        restRestaurants = [];
        if (restaurantController.restaurantModel != null &&
            restaurantController.restaurantModel.restaurants.isNotEmpty) {
          restaurantController.restaurantModel.restaurants.forEach((element) {
            if (element.trending == 1 && element.venueType == 0) {
              restRestaurants.add(element.copyWith());
            }
          });
        }
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await VenuesScreen.getVenuesList(false, offset: offset);
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (restRestaurants.length > 0)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 10),
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
                                            Dimensions.HEIGHT_OF_CHEF_CELL + 50,
                                        child: Center(
                                          child: VenuesTrendingWidget(
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
                            ],
                          ),
                        ),
                      if (restRestaurants.isEmpty)
                        NoDataScreen(
                          text: 'No Trending Venues'.tr,
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
            ),
          ],
        );
      }),
    );
  }
}
