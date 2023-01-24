import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/venues_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedVenuesWidget extends StatelessWidget {
  final List<Restaurant> restaurants;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final bool isCampaign;
  final String type;
  final Function(String type) onVegFilterTap;

  FeaturedVenuesWidget({
    @required this.restaurants,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.isCampaign = false,
    this.type,
    this.onVegFilterTap,
    this.padding = const EdgeInsets.all(
      Dimensions.PADDING_SIZE_SMALL,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        restaurants.length > 0
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: Dimensions.HEIGHT_OF_CHEF_CELL + 50,
                child: ListView.builder(
                  key: UniqueKey(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: isScrollable ? false : true,
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    return VenuesViewWidget(
                      restaurant: restaurants[index],
                      tagIndex: 0,
                      showReservation: true,
                      cellWidth: MediaQuery.of(context).size.width * 0.86,
                    );
                  },
                ),
              )
            : NoDataScreen(
                text: 'no_restaurant_data_found'.tr,
              ),
      ],
    );
  }
}
