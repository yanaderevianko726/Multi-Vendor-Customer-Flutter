import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/home/theme1/theme1_home_screen.dart';
import 'package:efood_multivendor/view/screens/venues/venues_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'other_premiums_view.dart';

class SwushdVenuesScreen extends StatefulWidget {
  final bool fromNav;
  final Function openDrawer;
  const SwushdVenuesScreen({
    Key key,
    this.fromNav,
    this.openDrawer,
  }) : super(key: key);
  @override
  State<SwushdVenuesScreen> createState() => _SwushdVenuesScreenState();
}

class _SwushdVenuesScreenState extends State<SwushdVenuesScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<Restaurant> featuredVenues = [];
  List<Restaurant> cafeVenues = [];
  List<Restaurant> coworkVenues = [];
  List<Restaurant> hotelVenues = [];
  List<Restaurant> loungeVenues = [];
  List<Restaurant> privateVenues = [];
  List<Restaurant> restaurants = [];
  var tapIndex = 0;
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
    double horPadding = 4;
    double tapWidth =
        (MediaQuery.of(context).size.width - horPadding * 5) / 4 - horPadding;
    double topPadding = 10;
    return GetBuilder<RestaurantController>(
      builder: (restaurantController) {
        featuredVenues = [];
        cafeVenues = [];
        coworkVenues = [];
        hotelVenues = [];
        loungeVenues = [];
        privateVenues = [];
        restaurants = [];

        if (restaurantController.restaurantModel != null &&
            restaurantController.restaurantModel.restaurants.isNotEmpty) {
          restaurantController.restaurantModel.restaurants.forEach((element) {
            if (element.venueType == 1) {
              if (element.featured == 1 && tapIndex == 0) {
                featuredVenues.add(element.copyWith());
              }
              if (cafeVenues.length < 5) {
                if (element.classify == 0) {
                  if (tapIndex == 0 || tapIndex == 3) {
                    if (element.featured != 1) {
                      cafeVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 1) {
                    if (element.trending == 1) {
                      cafeVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 2) {
                    if (element.isNew == 1) {
                      cafeVenues.add(element.copyWith());
                    }
                  }
                }
              }
              if (coworkVenues.length < 5) {
                if (element.classify == 1) {
                  if (tapIndex == 0 || tapIndex == 3) {
                    if (element.featured != 1) {
                      coworkVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 1) {
                    if (element.trending == 1) {
                      coworkVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 2) {
                    if (element.isNew == 1) {
                      coworkVenues.add(element.copyWith());
                    }
                  }
                }
              }
              if (hotelVenues.length < 5) {
                if (element.classify == 2) {
                  if (tapIndex == 0 || tapIndex == 3) {
                    if (element.featured != 1) {
                      hotelVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 1) {
                    if (element.trending == 1) {
                      hotelVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 2) {
                    if (element.isNew == 1) {
                      hotelVenues.add(element.copyWith());
                    }
                  }
                }
              }
              if (loungeVenues.length < 5) {
                if (element.classify == 3) {
                  if (tapIndex == 0 || tapIndex == 3) {
                    if (element.featured != 1) {
                      loungeVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 1) {
                    if (element.trending == 1) {
                      loungeVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 2) {
                    if (element.isNew == 1) {
                      loungeVenues.add(element.copyWith());
                    }
                  }
                }
              }
              if (privateVenues.length < 5) {
                if (element.classify == 4) {
                  if (tapIndex == 0 || tapIndex == 3) {
                    if (element.featured != 1) {
                      privateVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 1) {
                    if (element.trending == 1) {
                      privateVenues.add(element.copyWith());
                    }
                  } else if (tapIndex == 2) {
                    if (element.isNew == 1) {
                      privateVenues.add(element.copyWith());
                    }
                  }
                }
              }
              if (restaurants.length < 5) {
                if (element.classify == 5) {
                  if (tapIndex == 0 || tapIndex == 3) {
                    if (element.featured != 1) {
                      restaurants.add(element.copyWith());
                    }
                  } else if (tapIndex == 1) {
                    if (element.trending == 1) {
                      restaurants.add(element.copyWith());
                    }
                  } else if (tapIndex == 2) {
                    if (element.isNew == 1) {
                      restaurants.add(element.copyWith());
                    }
                  }
                }
              }
            }

            print('=== classify: ${element.classify}');
          });
        }

        return GetBuilder<CartController>(
          builder: (cartController) {
            return WillPopScope(
              onWillPop: () async {
                Get.back();
                return false;
              },
              child: Scaffold(
                body: SafeArea(
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        elevation: 2,
                        toolbarHeight: !widget.fromNav
                            ? 56 + topPadding
                            : MediaQuery.of(context).viewPadding.top +
                                28 +
                                topPadding,
                        automaticallyImplyLeading: false,
                        backgroundColor: Theme.of(context).cardColor,
                        titleSpacing: 0,
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: !widget.fromNav
                                    ? 56 + topPadding
                                    : MediaQuery.of(context).viewPadding.top +
                                        28 +
                                        topPadding,
                                padding: EdgeInsets.only(
                                  top: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .grey[Get.isDarkMode ? 800 : 200],
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                    ),
                                    if (!widget.fromNav)
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            size: 24,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color,
                                          ),
                                        ),
                                      ),
                                    if (widget.fromNav)
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.openDrawer != null)
                                            widget.openDrawer();
                                        },
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.menu,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Spacer(),
                                    Text(
                                      'SWUSHD ${'venues'.tr}',
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color,
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                          RouteHelper.getCartRoute(),
                                        ),
                                        child: Badge(
                                          badgeContent: Text(
                                            '${cartController.cartList != null && cartController.cartList.isNotEmpty ? cartController.cartList.length : 0}',
                                            style: robotoRegular.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/image/ic_cart.png',
                                            width: 22,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: topPadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverDelegate(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 56,
                            color: Theme.of(context).cardColor,
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        tapIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      width: tapWidth,
                                      height: 38,
                                      margin: EdgeInsets.only(left: 6),
                                      decoration: BoxDecoration(
                                        color: tapIndex == 0
                                            ? Theme.of(context).cardColor
                                            : null,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Center(
                                          child: Text(
                                            '${'All Premium'.tr}',
                                            style: robotoMedium.copyWith(
                                              fontSize: 11,
                                              color: tapIndex == 0
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        tapIndex = 1;
                                      });
                                    },
                                    child: Container(
                                      width: tapWidth,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: tapIndex == 1
                                            ? Theme.of(context).cardColor
                                            : null,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Center(
                                          child: Text(
                                            '${'Trending'.tr}',
                                            style: robotoMedium.copyWith(
                                              fontSize: 11,
                                              color: tapIndex == 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        tapIndex = 2;
                                      });
                                    },
                                    child: Container(
                                      width: tapWidth,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: tapIndex == 2
                                            ? Theme.of(context).cardColor
                                            : null,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Center(
                                          child: Text(
                                            '${'New'.tr}',
                                            style: robotoMedium.copyWith(
                                              fontSize: 11,
                                              color: tapIndex == 2
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        tapIndex = 3;
                                      });
                                    },
                                    child: Container(
                                      width: tapWidth,
                                      height: 38,
                                      margin: EdgeInsets.only(right: 6),
                                      decoration: BoxDecoration(
                                        color: tapIndex == 3
                                            ? Theme.of(context).cardColor
                                            : null,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Center(
                                          child: Text(
                                            '${'NearBy'.tr}',
                                            style: robotoMedium.copyWith(
                                              fontSize: 11,
                                              color: tapIndex == 3
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          width: Dimensions.WEB_MAX_WIDTH,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              if (featuredVenues.length > 0)
                                OtherPremiumsView(
                                  topTitle: '${'Featured Venues'.tr}',
                                  otherVenues: featuredVenues,
                                  onCLickViewAll: () {},
                                ),
                              if (cafeVenues.length > 0)
                                OtherPremiumsView(
                                  topTitle: '${'Cafes'.tr}',
                                  tagIndex: tapIndex,
                                  otherVenues: cafeVenues,
                                  onCLickViewAll: () {},
                                ),
                              if (coworkVenues.length > 0)
                                OtherPremiumsView(
                                  topTitle: '${'Co-Work Hubs'.tr}',
                                  tagIndex: tapIndex,
                                  otherVenues: coworkVenues,
                                  onCLickViewAll: () {},
                                ),
                              if (hotelVenues.length > 0)
                                OtherPremiumsView(
                                  topTitle: '${'Hotels'.tr}',
                                  tagIndex: tapIndex,
                                  otherVenues: hotelVenues,
                                  onCLickViewAll: () {},
                                ),
                              if (loungeVenues.length > 0)
                                OtherPremiumsView(
                                  topTitle: '${'Lounges'.tr}',
                                  tagIndex: tapIndex,
                                  otherVenues: loungeVenues,
                                  onCLickViewAll: () {},
                                ),
                              if (privateVenues.length > 0)
                                OtherPremiumsView(
                                  topTitle: '${'Private Venues'.tr}',
                                  tagIndex: tapIndex,
                                  otherVenues: privateVenues,
                                  onCLickViewAll: () {},
                                ),
                              if (restaurants.length > 0)
                                OtherPremiumsView(
                                  topTitle: '${'Restaurants'.tr}',
                                  tagIndex: tapIndex,
                                  otherVenues: restaurants,
                                  onCLickViewAll: () {},
                                ),
                              if (featuredVenues.isEmpty &&
                                  cafeVenues.isEmpty &&
                                  coworkVenues.isEmpty &&
                                  hotelVenues.isEmpty &&
                                  loungeVenues.isEmpty &&
                                  privateVenues.isEmpty &&
                                  restaurants.isEmpty)
                                NoDataScreen(
                                  text: 'No any SWUSHD Venues'.tr,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
