import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/venues_view_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/featured_rentals_logo_widge.dart';
import 'package:efood_multivendor/view/screens/home/widget/main_commission_widget.dart';
import 'package:efood_multivendor/view/screens/venues/others_venues_view.dart';
import 'package:efood_multivendor/view/screens/venues/venues_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllVenuesScreen extends StatefulWidget {
  const AllVenuesScreen({Key key}) : super(key: key);
  @override
  State<AllVenuesScreen> createState() => _AllVenuesScreenState();
}

class _AllVenuesScreenState extends State<AllVenuesScreen> {
  List<Restaurant> featuredVenues = [];
  List<Restaurant> venues = [];
  List<Restaurant> premiums = [];
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
        featuredVenues = [];
        venues = [];
        premiums = [];
        if (restaurantController.restaurantModel != null &&
            restaurantController.restaurantModel.restaurants.isNotEmpty) {
          restaurantController.restaurantModel.restaurants.forEach((element) {
            if (element.venueType == 1) {
              premiums.add(element.copyWith());
            } else {
              if (element.featured == 1) {
                featuredVenues.add(element.copyWith());
              } else {
                venues.add(element.copyWith());
              }
            }
          });
        }
        print('=== featuredCount: ${featuredVenues.length}');
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
                      featuredVenues.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                top: 12,
                                right: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'featured_venues'.tr,
                                    style: robotoMedium.copyWith(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              Dimensions.HEIGHT_OF_CHEF_CELL +
                                                  50,
                                          child: ListView.builder(
                                            key: UniqueKey(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: featuredVenues.length,
                                            itemBuilder: (context, index) {
                                              return VenuesViewWidget(
                                                restaurant:
                                                    featuredVenues[index],
                                                tagIndex: 0,
                                                showReservation: true,
                                                cellWidth:
                                                    featuredVenues.length > 1
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.86
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.92,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      if (premiums.length > 0)
                        OthersVenuesView(
                          topTitle: 'Premium Venues'.tr,
                          tagIndex: 0,
                          venues: premiums,
                          onCLickViewAll: () {
                            Get.toNamed(
                              RouteHelper.getSwushdVenuesRoute(
                                '',
                              ),
                            );
                          },
                        ),
                      if (venues.length > 0)
                        Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${'Standard Venues'.tr}',
                                  style: robotoMedium.copyWith(fontSize: 16),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            for (int index = 0; index < venues.length; index++)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: Dimensions.HEIGHT_OF_CHEF_CELL + 50,
                                margin: EdgeInsets.symmetric(vertical: 2),
                                child: Center(
                                  child: VenuesViewWidget(
                                    restaurant: venues[index],
                                    tagIndex: 0,
                                    cellWidth:
                                        MediaQuery.of(context).size.width *
                                            0.92,
                                  ),
                                ),
                              )
                          ],
                        ),
                      if (featuredVenues.isEmpty &&
                          premiums.isEmpty &&
                          venues.isEmpty)
                        NoDataScreen(
                          text: 'No Any Venues'.tr,
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
