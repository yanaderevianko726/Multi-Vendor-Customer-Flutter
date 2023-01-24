import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'foods_widget.dart';

class FavoriteFoodsView extends StatefulWidget {
  final List<Product> products;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final String type;
  final Function(String type) onVegFilterTap;

  const FavoriteFoodsView({
    Key key,
    @required this.products,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.padding = const EdgeInsets.all(
      Dimensions.PADDING_SIZE_SMALL,
    ),
    this.noDataText,
    this.isCampaign = false,
    this.type = 'all',
    this.onVegFilterTap,
  }) : super(key: key);

  @override
  State<FavoriteFoodsView> createState() => _FavoriteFoodsViewState();
}

class _FavoriteFoodsViewState extends State<FavoriteFoodsView> {
  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    _isNull = widget.products == null;
    if (!_isNull) {
      _length = widget.products.length;
    }
    return !_isNull
        ? _length > 0
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    for (int index = 0; index < widget.products.length; index++)
                      FoodsWidget(
                        product: widget.products[index],
                        isCampaign: widget.isCampaign,
                      )
                  ],
                ))
            : NoDataScreen(
                text: widget.noDataText != null
                    ? widget.noDataText
                    : 'no_food_available'.tr,
              )
        : Container();
  }
}
