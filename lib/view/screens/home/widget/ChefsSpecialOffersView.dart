import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/featured_tag.dart';
import 'package:efood_multivendor/view/base/rating_simplified.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ChefsSpecialOffersView extends StatelessWidget {
  final Vendor vendor;
  final List<Restaurant> restaurants;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  final int style;
  final double wAdjust;
  final tag;
  final String imgUrl;
  final double widthOfChefVenueCell;

  ChefsSpecialOffersView({
    @required this.vendor,
    @required this.length,
    this.inRestaurant = false,
    this.isCampaign = false,
    this.restaurants,
    this.style = 0,
    this.wAdjust = 0.84,
    this.widthOfChefVenueCell = 280,
    this.tag = -1,
    this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    var imgVendorUrlPrefix = '${_baseUrls.vendorAvatarUrl}/';
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double rightWidth = (widthOfChefVenueCell - 20) / 2 - 16;

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
    var restIndex =
        restaurants.indexWhere((element) => element.vendorId == vendor.id);
    if (restIndex != -1) {
      restaurant = restaurants[restIndex];
    }

    double padLeft = 6;
    if (restaurant.featured == 1 ||
        restaurant.trending == 1 ||
        restaurant.isNew == 1) padLeft = 0;

    var dTag = tag;
    if (dTag == -1) {
      if (vendor.vFeatured == 1) {
        dTag = 0;
      } else if (vendor.vTrending == 1) {
        dTag = 1;
      } else if (vendor.vIsNew == 1) {
        dTag = 2;
      }
    }

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
      return restIndex != -1
          ? InkWell(
              onTap: () {},
              child: style == 0
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: Dimensions.HEIGHT_OF_CHEF_CELL + 48,
                      padding: EdgeInsets.all(
                        6,
                      ),
                      color: Theme.of(context).cardColor,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (restaurant.coverPhoto != null &&
                                      restaurant.coverPhoto.isNotEmpty)
                                  ? Stack(
                                      children: [
                                        CustomImage(
                                          image: '$imgUrl',
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 182,
                                          fit: BoxFit.cover,
                                        ),
                                        Row(
                                          children: [
                                            dTag == 0
                                                ? FeaturedTag(
                                                    fontSize: 16,
                                                    style: 0,
                                                  )
                                                : dTag == 1
                                                    ? DiscountTag(
                                                        discount: 0,
                                                        discountType: '',
                                                        type: 2,
                                                      )
                                                    : dTag == 2
                                                        ? DiscountTag(
                                                            discount: 0,
                                                            discountType: '',
                                                            type: 3,
                                                          )
                                                        : SizedBox(),
                                            if (restaurant.discount != null &&
                                                restaurant.discount.discount >
                                                    0)
                                              DiscountTag(
                                                discount: restaurant
                                                    .discount.discount,
                                                discountType: restaurant
                                                    .discount.discountType,
                                              ),
                                            if (restaurant.freeDelivery)
                                              DiscountTag(
                                                discount: 0,
                                                discountType: '',
                                                type: 1,
                                              ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${'Chef'.tr} ${vendor.fName} ${vendor.lName}',
                                            style: robotoMedium.copyWith(
                                              fontSize: 18,
                                            ),
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
                                                      'you_are_not_logged_in'
                                                          .tr);
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: _desktop
                                                      ? Dimensions
                                                          .PADDING_SIZE_SMALL
                                                      : 0,
                                                ),
                                                child: Image.asset(
                                                  _isWished
                                                      ? 'assets/image/ic_hart.png'
                                                      : 'assets/image/ic_heart_grey.png',
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
                                    Container(
                                      width: double.infinity,
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
                                          Expanded(
                                            child: RatingSimplified(
                                              rating: restaurant.avgRating,
                                              size: 14,
                                              ratingCount:
                                                  restaurant.ratingCount,
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
                                      height: 6,
                                    ),
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
                                                    style:
                                                        TextStyle(fontSize: 10),
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
                                                    '$strDistance',
                                                    style:
                                                        TextStyle(fontSize: 10),
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
                          Column(
                            children: [
                              SizedBox(
                                height: 122,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 16,
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
                                            image:
                                                '$imgVendorUrlPrefix${vendor.image}',
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
                    )
                  : Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * wAdjust,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.RADIUS_SMALL,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                                spreadRadius: 1,
                                blurRadius: 3,
                              )
                            ],
                            color: Theme.of(context).cardColor,
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
                                            Dimensions.RADIUS_SMALL,
                                          ),
                                          child: CustomImage(
                                            image: '$imgUrl',
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 172,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 22),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${vendor.fName} ${vendor.lName}',
                                                style: robotoMedium.copyWith(
                                                  fontSize: 18,
                                                ),
                                                maxLines: _desktop ? 2 : 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            GetBuilder<WishListController>(
                                              builder: (wishController) {
                                                bool _isWished = wishController
                                                    .wishRestIdList
                                                    .contains(restaurant.id);
                                                return InkWell(
                                                  onTap: () {
                                                    if (Get.find<
                                                            AuthController>()
                                                        .isLoggedIn()) {
                                                      _isWished
                                                          ? wishController
                                                              .removeFromWishList(
                                                              restaurant.id,
                                                              true,
                                                            )
                                                          : wishController
                                                              .addToWishList(
                                                              Product(),
                                                              restaurant,
                                                              true,
                                                            );
                                                    } else {
                                                      showCustomSnackBar(
                                                          'you_are_not_logged_in'
                                                              .tr);
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: _desktop
                                                          ? Dimensions
                                                              .PADDING_SIZE_SMALL
                                                          : 0,
                                                    ),
                                                    child: Image.asset(
                                                      _isWished
                                                          ? 'assets/image/ic_hart.png'
                                                          : 'assets/image/ic_heart_grey.png',
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
                                        SizedBox(height: 10),
                                        SizedBox(
                                          height: 18,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: RatingSimplified(
                                                  rating: restaurant.avgRating,
                                                  size: 14,
                                                  ratingCount:
                                                      restaurant.ratingCount,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: dollars,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL,
                                        ),
                                        SizedBox(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 104,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                50,
                                              ),
                                              child: CustomImage(
                                                image:
                                                    '$imgVendorUrlPrefix${vendor.image}',
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
                          width: MediaQuery.of(context).size.width *
                              Dimensions.VENUE_WIDTH_ADJUSTMENT,
                          margin: EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: padLeft,
                                  ),
                                  dTag == 0
                                      ? FeaturedTag(
                                          fontSize: 16,
                                          style: 2,
                                        )
                                      : dTag == 1
                                          ? DiscountTag(
                                              discount: 0,
                                              discountType: '',
                                              type: 2,
                                              style: 2,
                                            )
                                          : dTag == 2
                                              ? DiscountTag(
                                                  discount: 0,
                                                  discountType: '',
                                                  type: 3,
                                                  style: 2,
                                                )
                                              : SizedBox(
                                                  width: 6,
                                                ),
                                  if (restaurant.discount != null &&
                                      restaurant.discount.discount > 0)
                                    DiscountTag(
                                      discount: restaurant.discount.discount,
                                      discountType:
                                          restaurant.discount.discountType,
                                    ),
                                  if (restaurant.freeDelivery &&
                                      restaurant.featured != 1)
                                    DiscountTag(
                                      discount: 0,
                                      discountType: '',
                                      type: 1,
                                    ),
                                  Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            )
          : SizedBox();
    });
  }
}
