import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cele_chef_widget.dart';

class CeleChefsView extends StatelessWidget {
  final List<Product> products;
  final List<Restaurant> restaurants;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final String type;
  final Function(String type) onVegFilterTap;

  CeleChefsView({
    @required this.restaurants,
    @required this.products,
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
  });

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    _isNull = products == null;
    if (!_isNull) {
      _length = products.length;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimensions.HEIGHT_OF_CHEF_CELL + 8,
      child: Column(
        children: [
          type != null
              ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
              : SizedBox(),
          !_isNull
              ? _length > 0
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: Dimensions.HEIGHT_OF_CHEF_CELL,
                      child: ListView.builder(
                        key: UniqueKey(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: isScrollable ? false : true,
                        itemCount: _length,
                        itemBuilder: (context, index) {
                          return CeleChefWidget(
                            product: products[index],
                            restaurants: restaurants,
                            index: index,
                            length: _length,
                            isCampaign: isCampaign,
                            inRestaurant: inRestaurantPage,
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
