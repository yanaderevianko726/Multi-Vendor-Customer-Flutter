import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/rating_simplified.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'featured_tag.dart';

class FeaturedChefWidget extends StatelessWidget {
  final Vendor vendor;
  final Restaurant restaurant;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  final double cellWidth;

  FeaturedChefWidget({
    @required this.vendor,
    @required this.restaurant,
    @required this.index,
    @required this.length,
    this.inRestaurant = false,
    this.isCampaign = false,
    this.cellWidth,
  });

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    var imgUrlPrefix = '${_baseUrls.restaurantImageUrl}/';
    var imgVendorUrlPrefix = '${_baseUrls.vendorAvatarUrl}/';

    double hPadding = Dimensions.PADDING_SIZE_SMALL;
    double rightWidth =
        (Dimensions.widthOfChefVenueCell - hPadding * 2) / 2 - 16;

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

    return GetBuilder<LocationController>(builder: (locationController) {
      var strDistance = 'calculating'.tr;
      double _distance = 0;
      var curLat = locationController.getUserAddress().latitude;
      var curLang = locationController.getUserAddress().longitude;
      print('=== restaurant: ${restaurant.latitude}, ${restaurant.longitude}');
      if (curLat != null && restaurant.latitude != null) {
        _distance = Geolocator.distanceBetween(
          double.parse(curLat),
          double.parse(curLang),
          double.parse(restaurant.latitude),
          double.parse(restaurant.longitude),
        );
        print('=== _distance: $_distance');
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
              RouteHelper.getRestaurantRoute(
                restaurant.id,
              ),
              arguments: RestaurantScreen(
                restaurant: restaurant,
              ),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              width: cellWidth,
              height: Dimensions.HEIGHT_OF_CHEF_CELL + 30,
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
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (restaurant.coverPhoto != null &&
                              restaurant.coverPhoto.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              child: CustomImage(
                                image: '$imgUrlPrefix${restaurant.logo}',
                                width: cellWidth,
                                height: 164,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: hPadding,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            SizedBox(
                              width: cellWidth,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${'Chef'.tr} ${vendor.fName} ${vendor.lName}',
                                      style:
                                          robotoMedium.copyWith(fontSize: 17),
                                      maxLines: _desktop ? 2 : 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GetBuilder<WishListController>(
                                    builder: (wishController) {
                                      bool _isWished = wishController
                                          .wishVendorIdList
                                          .contains(vendor.id);
                                      return InkWell(
                                        onTap: () {
                                          if (Get.find<AuthController>()
                                              .isLoggedIn()) {
                                            _isWished
                                                ? wishController
                                                    .removeVendorWishList(
                                                    vendor.id,
                                                  )
                                                : wishController
                                                    .addVendorToWishList(
                                                    vendor,
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
                                            'assets/image/ic_hart.png',
                                            width: _desktop ? 30 : 22,
                                            fit: BoxFit.fitWidth,
                                            color: _isWished
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .disabledColor,
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
                            Container(
                              width: cellWidth,
                              margin: EdgeInsets.only(
                                left: 6,
                                top: 6,
                              ),
                              child: Text(
                                '${restaurant.name}',
                                style: robotoMedium.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                                maxLines: _desktop ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 18,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: RatingSimplified(
                                      rating: restaurant.avgRating,
                                      size: 14,
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
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 24,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Image.asset(
                                            'assets/image/ic_location_white.png',
                                            width: 10,
                                            fit: BoxFit.fitWidth,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${restaurant.address}',
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 96,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              50,
                            ),
                            child: Container(
                              width: 86,
                              height: 86,
                              color: Colors.white,
                              padding: EdgeInsets.all(1.0),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    50,
                                  ),
                                  child: CustomImage(
                                    image: '$imgVendorUrlPrefix${vendor.image}',
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: cellWidth,
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: FeaturedTag(
                      fontSize: 16,
                      style: 1,
                    ),
                  ),
                  if (restaurant.discount != null &&
                      restaurant.discount.discount > 0)
                    DiscountTag(
                      discount: restaurant.discount.discount,
                      discountType: restaurant.discount.discountType,
                    ),
                  Spacer(),
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
