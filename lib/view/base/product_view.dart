import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:efood_multivendor/view/base/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final List<Product> products;
  final List<Restaurant> restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final String type;
  final Function(String type) onVegFilterTap;
  final bool showTopTitles;
  final bool showCheckoutBtn;

  ProductView({
    @required this.restaurants,
    @required this.products,
    @required this.isRestaurant,
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
    this.showTopTitles = true,
    this.showCheckoutBtn = true,
  });

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    if (isRestaurant) {
      _isNull = restaurants == null;
      if (!_isNull) {
        _length = restaurants.length;
      }
    } else {
      _isNull = products == null;
      if (!_isNull) {
        _length = products.length;
      }
    }
    ScrollController scrollController = ScrollController();

    return Column(
      children: [
        type != null
            ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
            : SizedBox(),
        !_isNull
            ? _length > 0
                ? ListView.builder(
                    key: UniqueKey(),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: _length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return ProductWidget(
                        isRestaurant: isRestaurant,
                        product: isRestaurant ? null : products[index],
                        restaurant: isRestaurant ? restaurants[index] : null,
                        showTopTitles: showTopTitles,
                        index: index,
                        length: _length,
                        isCampaign: isCampaign,
                        inRestaurant: inRestaurantPage,
                        showCheckoutBtn: showCheckoutBtn,
                      );
                    },
                  )
                : NoDataScreen(
                    text: noDataText != null
                        ? noDataText
                        : isRestaurant
                            ? 'no_restaurant_available'.tr
                            : 'no_food_available'.tr,
                  )
            : Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      'Loading product now...'.tr,
                      style: robotoMedium.copyWith(
                        fontSize: MediaQuery.of(context).size.height * 0.0175,
                        color: Theme.of(context).disabledColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
