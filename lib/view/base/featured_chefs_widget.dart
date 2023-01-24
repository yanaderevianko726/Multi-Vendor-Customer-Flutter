import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'featured_chef_widget.dart';

class FeaturedChefsWidget extends StatelessWidget {
  final List<Vendor> featuredVendors;
  final List<Restaurant> restaurants;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final String type;
  final Function(String type) onVegFilterTap;

  FeaturedChefsWidget({
    @required this.featuredVendors,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.padding = const EdgeInsets.all(
      Dimensions.PADDING_SIZE_SMALL,
    ),
    this.noDataText,
    this.isCampaign = false,
    this.inRestaurantPage = false,
    this.type,
    this.onVegFilterTap,
    this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    _isNull = featuredVendors == null;
    if (!_isNull) {
      _length = featuredVendors.length;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          type != null
              ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
              : SizedBox(),
          !_isNull
              ? _length > 0
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: Dimensions.HEIGHT_OF_CHEF_CELL + 40,
                      child: ListView.builder(
                        key: UniqueKey(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: isScrollable ? false : true,
                        itemCount: _length,
                        itemBuilder: (context, index) {
                          return FeaturedChefWidget(
                            vendor: featuredVendors[index],
                            restaurant: restaurants[index],
                            index: index,
                            length: _length,
                            isCampaign: isCampaign,
                            inRestaurant: inRestaurantPage,
                            cellWidth: _length == 1
                                ? MediaQuery.of(context).size.width * 0.92
                                : MediaQuery.of(context).size.width * 0.86,
                          );
                        },
                      ),
                    )
                  : NoDataScreen(
                      text: noDataText != null
                          ? noDataText
                          : 'no_food_available'.tr,
                    )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: Dimensions.HEIGHT_OF_CHEF_CELL,
                  child: ListView.builder(
                    key: UniqueKey(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: isScrollable ? false : true,
                    itemCount: shimmerLength,
                    padding: padding,
                    itemBuilder: (context, index) {
                      return ProductShimmer(
                        isEnabled: _isNull,
                        isRestaurant: false,
                        hasDivider: index != shimmerLength - 1,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
