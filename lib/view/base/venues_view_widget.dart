import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/rating_simplified.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'discount_tag.dart';
import 'featured_tag.dart';

class VenuesViewWidget extends StatelessWidget {
  final Restaurant restaurant;
  final int tagIndex;
  final bool isCampaign;
  final bool showReservation;
  final double cellWidth;
  final double cellHeight;

  VenuesViewWidget({
    @required this.restaurant,
    @required this.cellWidth,
    this.tagIndex = 0,
    this.isCampaign = false,
    this.showReservation = false,
    this.cellHeight,
  });

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    bool _isAvailable;
    String _image;

    _image = restaurant.coverPhoto;
    _isAvailable = restaurant.status == 1 && restaurant.active;

    double hPadding = Dimensions.PADDING_SIZE_SMALL;
    double rightWidth =
        (Dimensions.widthOfChefVenueCell - hPadding * 2) / 2 - 20;

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

    double padLeft = 6;
    if (restaurant.featured == 1 ||
        restaurant.trending == 1 ||
        restaurant.isNew == 1) padLeft = 0;

    print('=== classify: ${restaurant.classify}');
    var classify = restaurant.classify == 0
        ? '${'Cafe'.tr}'
        : restaurant.classify == 1
            ? '${'Co-Work Hub'.tr}'
            : restaurant.classify == 2
                ? '${'Hotel'.tr}'
                : restaurant.classify == 3
                    ? '${'Lounge'.tr}'
                    : restaurant.classify == 4
                        ? '${'Private Members Club'.tr}'
                        : restaurant.classify == 5
                            ? '${'Restaurant'.tr}'
                            : '';
    print('=== classifyStr: $classify');
    return GetBuilder<LocationController>(builder: (locationController) {
      var strDistance = 'calculating'.tr;
      double _distance = 0;
      var curLat = locationController.getUserAddress().latitude;
      var curLong = locationController.getUserAddress().longitude;
      if (curLat != null && restaurant.latitude != null) {
        _distance = Geolocator.distanceBetween(
          double.parse(curLat),
          double.parse(curLong),
          double.parse(restaurant.latitude),
          double.parse(restaurant.longitude),
        );
        if (_distance < 1000) {
          strDistance = '${_distance.toStringAsFixed(0)} m ${'away'.tr}';
        } else if (_distance < 1610) {
          _distance /= 1000;
          strDistance = '${_distance.toStringAsFixed(1)} Kms ${'away'.tr}';
        } else {
          _distance /= 1852;
          strDistance = '${_distance.toStringAsFixed(0)} Miles ${'away'.tr}';
        }
      }
      return InkWell(
        onTap: () {
          if (restaurant != null) {
            Get.toNamed(
              RouteHelper.getRestaurantRoute(restaurant.id),
              arguments: RestaurantScreen(restaurant: restaurant),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              width: cellWidth,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                                10,
                              ),
                              child: CustomImage(
                                image:
                                    '${isCampaign ? _baseUrls.campaignImageUrl : _baseUrls.restaurantCoverPhotoUrl}'
                                    '/${restaurant.coverPhoto}',
                                width: cellWidth,
                                height: 182,
                                fit: BoxFit.cover,
                              ),
                            ),
                            _isAvailable
                                ? SizedBox()
                                : NotAvailableWidget(isRestaurant: true),
                          ],
                        )
                      : SizedBox.shrink(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: Dimensions.widthOfChefVenueCell,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  restaurant.name,
                                  style: robotoMedium.copyWith(
                                    fontSize: 16,
                                  ),
                                  maxLines: _desktop ? 2 : 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GetBuilder<WishListController>(
                                  builder: (wishController) {
                                bool _isWished = wishController.wishRestIdList
                                    .contains(restaurant.id);
                                return InkWell(
                                  onTap: () {
                                    if (Get.find<AuthController>()
                                        .isLoggedIn()) {
                                      _isWished
                                          ? wishController.removeFromWishList(
                                              restaurant.id, true)
                                          : wishController.addToWishList(
                                              Product(), restaurant, true);
                                    } else {
                                      showCustomSnackBar(
                                          'you_are_not_logged_in'.tr);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: _desktop
                                            ? Dimensions.PADDING_SIZE_SMALL
                                            : 0),
                                    child: Icon(
                                      _isWished
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: _desktop ? 30 : 25,
                                      color: _isWished
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '$classify',
                              style: robotoMedium.copyWith(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 6),
                        SizedBox(
                          height: 18,
                          child: Row(
                            children: [
                              Expanded(
                                child: RatingSimplified(
                                  rating: restaurant.avgRating,
                                  size: _desktop ? 15 : 12,
                                  ratingCount: restaurant.ratingCount,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: dollars,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 7),
                        SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/image/ic_location_white.png',
                                      width: 10,
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
                                        maxLines: 2,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        '$strDistance',
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
                  SizedBox(
                    width: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: cellWidth,
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: padLeft,
                  ),
                  restaurant.featured == 1
                      ? FeaturedTag(
                          fontSize: 16,
                          style: 1,
                        )
                      : restaurant.trending == 1
                          ? DiscountTag(
                              discount: 0,
                              discountType: '',
                              type: 2,
                              style: 1,
                            )
                          : restaurant.isNew == 1
                              ? DiscountTag(
                                  discount: 0,
                                  discountType: '',
                                  type: 3,
                                  style: 1,
                                )
                              : SizedBox(),
                  if (restaurant.discount != null &&
                      restaurant.discount.discount > 0)
                    DiscountTag(
                      discount: restaurant.discount.discount,
                      discountType: restaurant.discount.discountType,
                    ),
                  if (restaurant.freeDelivery && restaurant.featured != 1)
                    DiscountTag(
                      discount: 0,
                      discountType: '',
                      type: 1,
                    ),
                  Spacer(),
                  if (showReservation)
                    Container(
                      width: 32,
                      height: 32,
                      margin: EdgeInsets.only(right: 8, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                        color: orangeLight,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/image/ic_reservation.png',
                          width: 22,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
