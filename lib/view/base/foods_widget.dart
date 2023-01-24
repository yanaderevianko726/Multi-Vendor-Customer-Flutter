import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag_without_image.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_simplified.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodsWidget extends StatelessWidget {
  final Product product;
  final bool isCampaign;

  FoodsWidget({
    @required this.product,
    this.isCampaign = false,
  });

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    String _image;

    _image = product.image;
    _discount = (product.restaurantDiscount == 0 || isCampaign)
        ? product.discount
        : product.restaurantDiscount;
    _discountType = (product.restaurantDiscount == 0 || isCampaign)
        ? product.discountType
        : 'percent';
    _isAvailable = DateConverter.isAvailable(
      product.availableTimeStarts,
      product.availableTimeEnds,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            (_image != null && _image.isNotEmpty)
                ? Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      child: CustomImage(
                        image:
                            '${isCampaign ? _baseUrls.campaignImageUrl : _baseUrls.productImageUrl}/${product.image}',
                        height: _desktop ? 120 : 88,
                        width: _desktop ? 120 : 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                    _isAvailable
                        ? SizedBox()
                        : NotAvailableWidget(isRestaurant: false),
                  ])
                : SizedBox.shrink(),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${product.name}',
                      style: robotoMedium.copyWith(
                        fontSize: 16,
                      ),
                      maxLines: _desktop ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      product.restaurantName ?? '',
                      style: robotoRegular.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).disabledColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: (_desktop) ? 5 : 2),
                    RatingSimplified(
                      rating: product.avgRating,
                      size: _desktop ? 15 : 14,
                      ratingCount: product.ratingCount,
                    ),
                    SizedBox(
                      height: (_desktop) ? 5 : 2,
                    ),
                    Row(children: [
                      Text(
                        PriceConverter.convertPrice(
                          product.price,
                          discount: _discount,
                          discountType: _discountType,
                        ),
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                      SizedBox(
                        width: _discount > 0
                            ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                            : 0,
                      ),
                      _discount > 0
                          ? Text(
                              PriceConverter.convertPrice(product.price),
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).disabledColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      (_image != null && _image.isNotEmpty)
                          ? SizedBox.shrink()
                          : DiscountTagWithoutImage(
                              discount: _discount,
                              discountType: _discountType,
                              freeDelivery: false,
                            ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Image.asset(
                        'assets/image/ic_distance.png',
                        width: 10,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      ),
                      Text(
                        '8888 Miles from you',
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ]),
                    SizedBox(height: 8),
                  ]),
            ),
            GetBuilder<WishListController>(builder: (wishController) {
              bool _isWished =
                  wishController.wishProductIdList.contains(product.id);
              return InkWell(
                onTap: () {
                  if (Get.find<AuthController>().isLoggedIn()) {
                    _isWished
                        ? wishController.removeFromWishList(product.id, false)
                        : wishController.addToWishList(
                            product,
                            Restaurant(),
                            false,
                          );
                  } else {
                    showCustomSnackBar('you_are_not_logged_in'.tr);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Icon(
                    _isWished ? Icons.favorite : Icons.favorite_border,
                    size: _desktop ? 30 : 25,
                    color: _isWished
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor,
                  ),
                ),
              );
            }),
          ]),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              SizedBox(
                width: 88,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    ResponsiveHelper.isMobile(context)
                        ? Get.bottomSheet(
                            ProductBottomSheet(
                              product: product,
                              inRestaurantPage: false,
                              isCampaign: isCampaign,
                            ),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          )
                        : Get.dialog(
                            Dialog(
                              child: ProductBottomSheet(
                                product: product,
                                inRestaurantPage: false,
                                isCampaign: isCampaign,
                              ),
                            ),
                          );
                  },
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'order_now'.tr,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: DottedLine(
              dashColor: Theme.of(context).disabledColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
