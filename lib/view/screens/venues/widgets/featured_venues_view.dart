import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/featured_venues_widget.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedVenueView extends StatefulWidget {
  const FeaturedVenueView({Key key}) : super(key: key);
  @override
  State<FeaturedVenueView> createState() => _FeaturedVenueViewState();
}

class _FeaturedVenueViewState extends State<FeaturedVenueView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      int featuredCount = 0;
      if (restaurantController.restaurantFeaturedList != null &&
          restaurantController.restaurantFeaturedList.isNotEmpty) {
        featuredCount = restaurantController.restaurantFeaturedList.length;
      }
      print('featuredCount: $featuredCount');
      return featuredCount > 0
          ? Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 12,
                right: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 6, 0, 2),
                    child: TitleWidget(
                      title: 'Featured Venues'.tr,
                      onTap: () {
                        Get.toNamed(
                          RouteHelper.getFeaturedVenuesAll(),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FeaturedVenuesWidget(
                      restaurants: restaurantController.restaurantFeaturedList,
                    ),
                  ),
                ],
              ),
            )
          : Container();
    });
  }
}
