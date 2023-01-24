import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/swushd_premium/widgets/premium_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PremiumListWidget extends StatelessWidget {
  final List<Restaurant> restaurants;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final bool isCampaign;
  final int tagIndex;

  const PremiumListWidget({
    Key key,
    @required this.restaurants,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.isCampaign = false,
    this.tagIndex,
    this.padding = const EdgeInsets.all(
      Dimensions.PADDING_SIZE_SMALL,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return restaurants.length > 0
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Dimensions.HEIGHT_OF_CHEF_CELL + 4,
            child: ListView.builder(
              key: UniqueKey(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: isScrollable ? false : true,
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return PremiumCellWidget(
                  restaurant: restaurants[index],
                  tagIndex: tagIndex,
                  length: restaurants.length,
                  showReservation: true,
                  cellWidth: restaurants.length > 1
                      ? MediaQuery.of(context).size.width * 0.86
                      : MediaQuery.of(context).size.width * 0.925,
                  cellHeight: Dimensions.HEIGHT_OF_CHEF_CELL + 4,
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
