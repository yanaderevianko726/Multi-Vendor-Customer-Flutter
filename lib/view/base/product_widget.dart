import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/discount_tag_without_image.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  final bool showTopTitles;
  final bool showCheckoutBtn;

  ProductWidget({
    @required this.product,
    @required this.isRestaurant,
    @required this.restaurant,
    @required this.index,
    @required this.length,
    this.inRestaurant = false,
    this.isCampaign = false,
    this.showTopTitles = true,
    this.showCheckoutBtn = true,
  });

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    String _image;
    if (isRestaurant) {
      _image = restaurant.logo;
      _discount =
          restaurant.discount != null ? restaurant.discount.discount : 0;
      _discountType = restaurant.discount != null
          ? restaurant.discount.discountType
          : 'percent';
      _isAvailable = restaurant.status == 1 && restaurant.active;
    } else {
      _image = product.image;
      _discount = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discount
          : product.restaurantDiscount;
      _discountType = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discountType
          : 'percent';
      print('=== _isAvailable: ');
      _isAvailable = DateConverter.isAvailable(
          product.availableTimeStarts, product.availableTimeEnds);
    }
    double cellWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        if (isRestaurant) {
          if (restaurant != null) {
            Get.toNamed(
              RouteHelper.getRestaurantRoute(restaurant.id),
              arguments: RestaurantScreen(restaurant: restaurant),
            );
          }
        } else {
          ResponsiveHelper.isMobile(context)
              ? Get.bottomSheet(
                  ProductBottomSheet(
                    product: product,
                    inRestaurantPage: inRestaurant,
                    isCampaign: isCampaign,
                    showCheckoutBtn: showCheckoutBtn,
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
                      showCheckoutBtn: showCheckoutBtn,
                    ),
                  ),
                );
        }
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: cellWidth,
          padding: EdgeInsets.all(
            10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child: Column(
            children: [
              Container(
                width: cellWidth,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isRestaurant ? restaurant.name : product.name,
                        style: robotoMedium.copyWith(
                          fontSize: 16,
                        ),
                        maxLines: _desktop ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GetBuilder<WishListController>(builder: (wishController) {
                      bool _isWished = isRestaurant
                          ? wishController.wishRestIdList
                              .contains(restaurant.id)
                          : wishController.wishProductIdList
                              .contains(product.id);
                      return InkWell(
                        onTap: () {
                          if (Get.find<AuthController>().isLoggedIn()) {
                            _isWished
                                ? wishController.removeFromWishList(
                                    isRestaurant ? restaurant.id : product.id,
                                    isRestaurant)
                                : wishController.addToWishList(
                                    product, restaurant, isRestaurant);
                          } else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
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
                  ],
                ),
              ),
              (_image != null && _image.isNotEmpty)
                  ? Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimensions.RADIUS_SMALL,
                          ),
                          child: CustomImage(
                            image:
                                '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                '/${isRestaurant ? restaurant.logo : product.image}',
                            width: cellWidth * 0.88,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (showTopTitles)
                          Row(
                            children: [
                              if (isRestaurant && restaurant.freeDelivery)
                                DiscountTag(
                                  discount: 0,
                                  discountType: '',
                                  type: 1,
                                ),
                              if (isRestaurant && restaurant.discount != null)
                                DiscountTag(
                                  discount: restaurant.discount.discount,
                                  discountType:
                                      restaurant.discount.discountType,
                                ),
                              if (!isRestaurant && product.discount != null)
                                DiscountTag(
                                  discount: product.discount,
                                  discountType: product.discountType,
                                ),
                            ],
                          ),
                        _isAvailable
                            ? SizedBox()
                            : NotAvailableWidget(isRestaurant: isRestaurant),
                      ],
                    )
                  : SizedBox.shrink(),
              if (isRestaurant)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    restaurant.address,
                    style: robotoRegular.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).disabledColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (!isRestaurant)
                SizedBox(
                  height: 12,
                ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !isRestaurant
                          ? RatingBar(
                              rating: isRestaurant
                                  ? restaurant.avgRating
                                  : product.avgRating,
                              size: _desktop ? 15 : 12,
                              ratingCount: isRestaurant
                                  ? restaurant.ratingCount
                                  : product.ratingCount,
                            )
                          : SizedBox(),
                      SizedBox(
                        height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      ),
                      isRestaurant
                          ? RatingBar(
                              rating: isRestaurant
                                  ? restaurant.avgRating
                                  : product.avgRating,
                              size: _desktop ? 15 : 12,
                              ratingCount: isRestaurant
                                  ? restaurant.ratingCount
                                  : product.ratingCount,
                            )
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    PriceConverter.convertPrice(
                                      product.price,
                                      discount: _discount,
                                      discountType: _discountType,
                                    ),
                                    style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: _discount > 0
                                      ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                      : 0,
                                ),
                                _discount > 0
                                    ? Text(
                                        PriceConverter.convertPrice(
                                          product.price,
                                        ),
                                        style: robotoMedium.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color:
                                              Theme.of(context).disabledColor,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                (_image != null && _image.isNotEmpty)
                                    ? SizedBox.shrink()
                                    : DiscountTagWithoutImage(
                                        discount: _discount,
                                        discountType: _discountType,
                                        freeDelivery: isRestaurant
                                            ? restaurant.freeDelivery
                                            : false,
                                      ),
                              ],
                            ),
                    ],
                  ),
                  Spacer(),
                  !isRestaurant
                      ? Container(
                          width: 120,
                          height: 30,
                          decoration: BoxDecoration(
                            color: blueDeep,
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'order_now'.tr,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
