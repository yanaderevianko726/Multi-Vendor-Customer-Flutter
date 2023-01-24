import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/venues_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenuesAnotherView extends StatelessWidget {
  final List<Restaurant> restaurants;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final bool isCampaign;
  final String type;
  final Function(String type) onVegFilterTap;

  VenuesAnotherView({
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
    bool _isNull = true;
    int _length = 0;

    _isNull = restaurants == null;
    if (!_isNull) {
      _length = restaurants.length;
    }

    return Column(
      children: [
        !_isNull
            ? _length > 0
                ? SizedBox(
                    height: Dimensions.HEIGHT_OF_CHEF_CELL + 32,
                    child: ListView.builder(
                      key: UniqueKey(),
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: isScrollable ? false : true,
                      itemCount: _length,
                      itemBuilder: (context, index) {
                        return VenuesViewWidget(
                          restaurant: restaurants[index],
                          tagIndex: 0,
                          isCampaign: isCampaign,
                          cellWidth: MediaQuery.of(context).size.width * 0.94,
                        );
                      },
                    ),
                  )
                : NoDataScreen(
                    text: 'no_restaurant_data_found'.tr,
                  )
            : ListView.builder(
                key: UniqueKey(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: isScrollable ? false : true,
                itemCount: shimmerLength,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return ProductShimmer(
                    isEnabled: _isNull,
                    isRestaurant: true,
                    hasDivider: index != shimmerLength - 1,
                  );
                },
              ),
      ],
    );
  }
}
