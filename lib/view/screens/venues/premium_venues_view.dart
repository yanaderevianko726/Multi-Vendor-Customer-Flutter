import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/premium_venues_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PremiumVenueView extends StatefulWidget {
  const PremiumVenueView({Key key}) : super(key: key);
  @override
  State<PremiumVenueView> createState() => _PremiumVenueViewState();
}

class _PremiumVenueViewState extends State<PremiumVenueView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      int premiumCount = 0;
      if (restaurantController.restaurantPremiumList != null &&
          restaurantController.restaurantPremiumList.isNotEmpty) {
        premiumCount = restaurantController.restaurantPremiumList.length;
      }
      return premiumCount > 0
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
                    'premium_venues'.tr,
                    style: robotoMedium.copyWith(fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: PremiumVenuesWidget(
                      restaurants: restaurantController.restaurantPremiumList,
                    ),
                  ),
                ],
              ),
            )
          : Container();
    });
  }
}
