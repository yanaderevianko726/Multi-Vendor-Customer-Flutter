import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'venues_cell_widget.dart';

class VenuesListWidget extends StatelessWidget {
  final List<Restaurant> restaurants;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final bool isCampaign;
  final int tagIndex;

  const VenuesListWidget({
    Key key,
    @required this.restaurants,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.isCampaign = false,
    this.tagIndex = 0,
    this.padding = const EdgeInsets.all(
      Dimensions.PADDING_SIZE_SMALL,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return restaurants.length > 0
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Dimensions.HEIGHT_OF_CHEF_CELL + 50,
            child: ListView.builder(
              key: UniqueKey(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: isScrollable ? false : true,
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return VenuesCellWidget(
                  restaurant: restaurants[index],
                  tagIndex: tagIndex,
                  showReservation: true,
                  cellWidth: restaurants.length > 1
                      ? MediaQuery.of(context).size.width * 0.86
                      : MediaQuery.of(context).size.width * 0.92,
                );
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(2.0),
            child: NoDataScreen(
              text: 'no_restaurant_data_found'.tr,
            ),
          );
  }
}
