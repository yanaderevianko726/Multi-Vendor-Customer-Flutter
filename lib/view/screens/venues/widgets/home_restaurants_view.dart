import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/venue_classify_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/util/venueClassifies.dart';
import 'package:efood_multivendor/view/base/venues_view_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/featured_rentals_logo_widge.dart';
import 'package:efood_multivendor/view/screens/home/widget/home_search_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/main_commission_widget.dart';
import 'package:efood_multivendor/view/screens/venues/others_venues_view.dart';
import 'package:efood_multivendor/view/screens/venues/venues_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeRestaurantsView extends StatefulWidget {
  final int kindIndex;
  const HomeRestaurantsView({
    Key key,
    this.kindIndex = 0,
  }) : super(key: key);
  @override
  _HomeRestaurantsViewState createState() => _HomeRestaurantsViewState();
}

class _HomeRestaurantsViewState extends State<HomeRestaurantsView> {
  List<Restaurant> featuredVenues = [];
  List<Restaurant> cafes = [];
  List<Restaurant> coworks = [];
  List<Restaurant> hotels = [];
  List<Restaurant> lounges = [];
  List<Restaurant> privates = [];
  List<Restaurant> restaurants = [];
  List<Restaurant> premiums = [];
  int offset = 1;
  int classifyIndex = 10;
  var searchKey = '';

  var searchChefName = true;

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
    return GetBuilder<VendorController>(builder: (vendorController) {
      List<int> vendorIds = [];
      if (searchChefName) {
        if (vendorController.allVendorList != null &&
            vendorController.allVendorList.isNotEmpty) {
          vendorController.allVendorList.forEach((vendor) {
            if (vendor.fName.contains(searchKey) ||
                vendor.lName.contains(searchKey)) {
              vendorIds.add(vendor.id);
            }
          });
        }
      }
      return GetBuilder<RestaurantController>(builder: (restaurantController) {
        featuredVenues = [];
        premiums = [];
        cafes = [];
        coworks = [];
        hotels = [];
        lounges = [];
        privates = [];
        restaurants = [];
        if (restaurantController.restaurantModel != null &&
            restaurantController.restaurantModel.restaurants.isNotEmpty) {
          restaurantController.restaurantModel.restaurants.forEach((venue) {
            if (venue.kindness == widget.kindIndex) {
              if (classifyIndex == 10) {
                if (searchKey == '') {
                  if (venue.featured == 1) {
                    featuredVenues.add(venue.copyWith());
                  } else {
                    if (venue.venueType == 1) {
                      premiums.add(venue);
                    } else {
                      if (venue.classify == 0) {
                        cafes.add(venue.copyWith());
                      } else if (venue.classify == 1) {
                        coworks.add(venue.copyWith());
                      } else if (venue.classify == 2) {
                        hotels.add(venue.copyWith());
                      } else if (venue.classify == 3) {
                        lounges.add(venue.copyWith());
                      } else if (venue.classify == 4) {
                        privates.add(venue.copyWith());
                      } else if (venue.classify == 5) {
                        restaurants.add(venue.copyWith());
                      }
                    }
                  }
                } else {
                  if (venue.name.toLowerCase().contains(searchKey) ||
                      vendorIds.contains(venue.vendorId)) {
                    if (venue.featured == 1) {
                      featuredVenues.add(venue.copyWith());
                    } else {
                      if (venue.venueType == 1) {
                        premiums.add(venue);
                      } else {
                        if (venue.classify == 0) {
                          cafes.add(venue.copyWith());
                        } else if (venue.classify == 1) {
                          coworks.add(venue.copyWith());
                        } else if (venue.classify == 2) {
                          hotels.add(venue.copyWith());
                        } else if (venue.classify == 3) {
                          lounges.add(venue.copyWith());
                        } else if (venue.classify == 4) {
                          privates.add(venue.copyWith());
                        } else if (venue.classify == 5) {
                          restaurants.add(venue.copyWith());
                        }
                      }
                    }
                  }
                }
              } else {
                if (venue.classify == classifyIndex) {
                  if (searchKey == '') {
                    if (venue.featured == 1) {
                      featuredVenues.add(venue.copyWith());
                    } else {
                      if (venue.venueType == 1) {
                        premiums.add(venue);
                      } else {
                        if (venue.classify == 0) {
                          cafes.add(venue.copyWith());
                        } else if (venue.classify == 1) {
                          coworks.add(venue.copyWith());
                        } else if (venue.classify == 2) {
                          hotels.add(venue.copyWith());
                        } else if (venue.classify == 3) {
                          lounges.add(venue.copyWith());
                        } else if (venue.classify == 4) {
                          privates.add(venue.copyWith());
                        } else if (venue.classify == 5) {
                          restaurants.add(venue.copyWith());
                        }
                      }
                    }
                  } else {
                    if (venue.name.toLowerCase().contains(searchKey) ||
                        vendorIds.contains(venue.vendorId)) {
                      if (venue.featured == 1) {
                        featuredVenues.add(venue.copyWith());
                      } else {
                        if (venue.venueType == 1) {
                          premiums.add(venue);
                        } else {
                          if (venue.classify == 0) {
                            cafes.add(venue.copyWith());
                          } else if (venue.classify == 1) {
                            coworks.add(venue.copyWith());
                          } else if (venue.classify == 2) {
                            hotels.add(venue.copyWith());
                          } else if (venue.classify == 3) {
                            lounges.add(venue.copyWith());
                          } else if (venue.classify == 4) {
                            privates.add(venue.copyWith());
                          } else if (venue.classify == 5) {
                            restaurants.add(venue.copyWith());
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          });
        }
        print('=== classifyIndex: $classifyIndex');
        var featureStr = widget.kindIndex == 0
            ? 'Featured ${'Restaurants'.tr}'
            : widget.kindIndex == 1
                ? 'Featured ${'Venues'.tr}'
                : widget.kindIndex == 2
                    ? 'Featured ${'Hotels'.tr}'
                    : widget.kindIndex == 3
                        ? 'Featured ${'Elite Venues'.tr}'
                        : widget.kindIndex == 4
                            ? 'Featured ${'Venue Rentals'.tr}'
                            : '';

        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: HomeSearchWidget(
                    searchText: searchKey,
                    hintText: 'Search'.tr,
                    onChangeText: (_text) {
                      print('=== searchText = $_text');
                      setState(() {
                        searchKey = _text;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                // InkWell(
                //   onTap: () {
                //     showSearchOptions();
                //   },
                //   child: Container(
                //     width: 48,
                //     height: 48,
                //     margin: EdgeInsets.only(right: 12),
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).cardColor,
                //       borderRadius: BorderRadius.circular(
                //         Dimensions.RADIUS_SMALL,
                //       ),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey[Get.isDarkMode ? 800 : 200],
                //           spreadRadius: 1,
                //           blurRadius: 5,
                //         )
                //       ],
                //     ),
                //     child: Center(
                //       child: Icon(
                //         Icons.keyboard_option_key_sharp,
                //         size: 22,
                //         color: Theme.of(context).primaryColor,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            venueClassifies.isNotEmpty
                ? Container(
                    width: double.infinity,
                    height: 88,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: VenueClassifyModel.listUIWidget(
                      venueClassifyModels: venueClassifies,
                      selIndex: classifyIndex,
                      onClickCell: (_clickIndex) {
                        setState(() {
                          classifyIndex = _clickIndex;
                        });
                      },
                    ),
                  )
                : Container(),
            RefreshIndicator(
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
                                  '$featureStr',
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
                                            Dimensions.HEIGHT_OF_CHEF_CELL + 50,
                                        child: ListView.builder(
                                          key: UniqueKey(),
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: featuredVenues.length,
                                          itemBuilder: (context, index) {
                                            return VenuesViewWidget(
                                              restaurant: featuredVenues[index],
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
                        topTitle: 'Premium Restaurants'.tr,
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
                    if (cafes.length > 0)
                      OthersVenuesView(
                        topTitle: 'Cafes'.tr,
                        tagIndex: 0,
                        venues: cafes,
                        onCLickViewAll: () {},
                      ),
                    if (coworks.length > 0)
                      OthersVenuesView(
                        topTitle: 'Co-Work Hubs'.tr,
                        tagIndex: 0,
                        venues: coworks,
                        onCLickViewAll: () {},
                      ),
                    if (hotels.length > 0)
                      OthersVenuesView(
                        topTitle: 'Hotels'.tr,
                        tagIndex: 0,
                        venues: hotels,
                        onCLickViewAll: () {},
                      ),
                    if (lounges.length > 0)
                      OthersVenuesView(
                        topTitle: 'Lounges'.tr,
                        tagIndex: 0,
                        venues: lounges,
                        onCLickViewAll: () {},
                      ),
                    if (privates.length > 0)
                      OthersVenuesView(
                        topTitle: 'Private Members Clubs'.tr,
                        tagIndex: 0,
                        venues: privates,
                        onCLickViewAll: () {},
                      ),
                    if (restaurants.length > 0)
                      OthersVenuesView(
                        topTitle: 'Restaurants'.tr,
                        tagIndex: 0,
                        venues: restaurants,
                        onCLickViewAll: () {},
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
            ),
          ],
        );
      });
    });
  }

  void showSearchOptions() {}
}

Widget searchOptionsSheet(BuildContext context, {Function onClickYes}) {
  return Container(
    width: Dimensions.WEB_MAX_WIDTH,
    padding: EdgeInsets.symmetric(
      horizontal: 14,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
      color: Colors.white,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 26,
        ),
        Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Image.asset(
              'assets/image/ic_table_services.png',
              width: 22,
              fit: BoxFit.fitWidth,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              '${'Did you received food?'.tr}',
              style: robotoMedium.copyWith(
                fontSize: 16,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset(
                'assets/image/ic_close.png',
                width: 22,
                fit: BoxFit.fitWidth,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              width: 8,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${'No'.tr}',
                      style: robotoMedium.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onClickYes(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${'Yes'.tr}',
                      style: robotoMedium.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 22,
        ),
      ],
    ),
  );
}
