import 'package:efood_multivendor/controller/featured_venue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'featured_rental_view.dart';

class FeaturedRentalsLogoWidge extends StatefulWidget {
  const FeaturedRentalsLogoWidge({Key key}) : super(key: key);
  @override
  _FeaturedRentalsLogoWidgeState createState() =>
      _FeaturedRentalsLogoWidgeState();
}

class _FeaturedRentalsLogoWidgeState extends State<FeaturedRentalsLogoWidge> {
  bool rentalViewMore = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeaturedVenueController>(
        builder: (featuredVenueController) {
      return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            for (var i = 0;
                i < featuredVenueController.featuredVenuesList.length;
                i++)
              FeaturedRentalView(
                featuredRestaurant:
                    featuredVenueController.featuredVenuesList[i],
                rentalViewMore: rentalViewMore,
                onClickMore: () {
                  setState(() {
                    rentalViewMore = !rentalViewMore;
                  });
                },
              ),
          ],
        ),
      );
    });
  }
}
