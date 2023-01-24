import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_simplified.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'discount_tag.dart';
import 'featured_tag.dart';

class CeleChefWidget extends StatelessWidget {
  final Product product;
  final List<Restaurant> restaurants;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;

  CeleChefWidget({
    @required this.product,
    @required this.restaurants,
    @required this.index,
    @required this.length,
    this.inRestaurant = false,
    this.isCampaign = false,
  });

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    bool _isAvailable;
    String _image;

    _image = product.image;
    _isAvailable = DateConverter.isAvailable(
        product.availableTimeStarts, product.availableTimeEnds);

    double hPadding = Dimensions.PADDING_SIZE_SMALL;
    double rightWidth =
        (Dimensions.widthOfChefVenueCell - hPadding * 2) / 2 - 14;

    List<Widget> dollars = [];
    dollars.add(SizedBox(
      width: 4,
    ));
    for (int i = 0; i < 4; i++) {
      if (i < 2) {
        dollars.add(Text(
          '\$',
          style: TextStyle(
            fontSize: 11,
            color: Colors.blue,
          ),
        ));
      } else {
        dollars.add(Text(
          '\$',
          style: TextStyle(
            fontSize: 11,
          ),
        ));
      }
    }

    Restaurant restaurant = Restaurant();
    restaurants.forEach((element) {
      if (element.id == product.restaurantId) {
        restaurant = element;
      }
    });

    double padLeft = 6;
    if (restaurant.featured == 1 ||
        restaurant.trending == 1 ||
        restaurant.isNew == 1) padLeft = 0;

    return InkWell(
      onTap: () {
        ResponsiveHelper.isMobile(context)
            ? Get.bottomSheet(
                ProductBottomSheet(
                  product: product,
                  inRestaurantPage: inRestaurant,
                  isCampaign: isCampaign,
                ),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              )
            : Get.dialog(
                Dialog(
                  child: ProductBottomSheet(
                    product: product,
                    inRestaurantPage: inRestaurant,
                    isCampaign: isCampaign,
                  ),
                ),
              );
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width *
                Dimensions.VENUE_WIDTH_ADJUSTMENT,
            height: Dimensions.HEIGHT_OF_CHEF_CELL,
            margin: EdgeInsets.all(
              6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Dimensions.RADIUS_SMALL,
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 300],
                  spreadRadius: 1,
                  blurRadius: 3,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (_image != null && _image.isNotEmpty)
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimensions.RADIUS_SMALL,
                            ),
                            child: CustomImage(
                              image:
                                  '${isCampaign ? _baseUrls.campaignImageUrl : _baseUrls.productImageUrl}/${product.image}',
                              width: MediaQuery.of(context).size.width *
                                  Dimensions.VENUE_WIDTH_ADJUSTMENT,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          _isAvailable
                              ? SizedBox()
                              : NotAvailableWidget(isRestaurant: false),
                        ],
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPadding,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      SizedBox(
                        width: Dimensions.widthOfChefVenueCell,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                                maxLines: _desktop ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GetBuilder<WishListController>(
                              builder: (wishController) {
                                bool _isWished = wishController
                                    .wishProductIdList
                                    .contains(product.id);
                                return InkWell(
                                  onTap: () {
                                    if (Get.find<AuthController>()
                                        .isLoggedIn()) {
                                      _isWished
                                          ? wishController.removeFromWishList(
                                              product.id,
                                              false,
                                            )
                                          : wishController.addToWishList(
                                              product,
                                              restaurant,
                                              false,
                                            );
                                    } else {
                                      showCustomSnackBar(
                                          'you_are_not_logged_in'.tr);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: _desktop
                                          ? Dimensions.PADDING_SIZE_SMALL
                                          : 0,
                                    ),
                                    child: Image.asset(
                                      _isWished
                                          ? 'assets/image/ic_hart.png'
                                          : 'assets/image/ic_heart_outline.png',
                                      width: _desktop ? 30 : 22,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 2,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      SizedBox(
                        height: 18,
                        child: Row(
                          children: [
                            Expanded(
                              child: RatingSimplified(
                                rating: product.avgRating,
                                size: 14,
                                ratingCount: product.ratingCount,
                              ),
                            ),
                            SizedBox(
                              width: rightWidth,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.monetization_on,
                                    size: 14,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: dollars,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      SizedBox(
                        height: 18,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/image/ic_location_white.png',
                                    width: 11,
                                    fit: BoxFit.fitWidth,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${restaurant.address}',
                                      style: TextStyle(fontSize: 10),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: rightWidth,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/image/ic_distance.png',
                                    width: 11,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${product.restaurantName}',
                                      style: TextStyle(fontSize: 10),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SizedBox(
                  width: padLeft,
                ),
                product.featured == 1
                    ? FeaturedTag(
                        fontSize: 16,
                        style: 1,
                      )
                    : product.trending == 1
                        ? DiscountTag(
                            discount: 0,
                            discountType: '',
                            type: 2,
                          )
                        : SizedBox(),
                if (product.discount != null && product.discount > 0)
                  DiscountTag(
                    discount: product.discount,
                    discountType: product.discountType,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
