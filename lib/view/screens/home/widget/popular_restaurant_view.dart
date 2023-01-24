import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PopularRestaurantView extends StatelessWidget {
  PopularRestaurantView();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      List<Restaurant> _restaurantList = restController.popularRestaurantList;
      ScrollController _scrollController = ScrollController();
      return (_restaurantList != null && _restaurantList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
                  child: TitleWidget(
                    title: 'popular_restaurants'.tr,
                    onTap: () => Get.toNamed(
                      RouteHelper.getAllRestaurantRoute(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: SizedBox(
                    height: Dimensions.HEIGHT_OF_RESTAURANT_CELL,
                    child: _restaurantList != null
                        ? ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: _restaurantList.length > 10
                                ? 10
                                : _restaurantList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    RouteHelper.getRestaurantRoute(
                                      _restaurantList[index].id,
                                    ),
                                    arguments: RestaurantScreen(
                                      restaurant: _restaurantList[index],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: Dimensions.WIDTH_OF_RESTAURANT_CELL,
                                  height: Dimensions.HEIGHT_OF_RESTAURANT_CELL,
                                  margin: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    right: Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[
                                            Get.find<ThemeController>()
                                                    .darkTheme
                                                ? 700
                                                : 300],
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(
                                                Dimensions.RADIUS_SMALL,
                                              ),
                                            ),
                                            child: CustomImage(
                                              image:
                                                  '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}'
                                                  '/${_restaurantList[index].coverPhoto}',
                                              width: Dimensions
                                                  .WIDTH_OF_RESTAURANT_CELL,
                                              height: Dimensions
                                                  .HEIGHT_OF_RESTAURANT_IMAGE_CELL,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (_restaurantList[index]
                                                      .discount !=
                                                  null)
                                                DiscountTag(
                                                  discount:
                                                      _restaurantList[index]
                                                          .discount
                                                          .discount,
                                                  discountType:
                                                      _restaurantList[index]
                                                          .discount
                                                          .discountType,
                                                  height: 28,
                                                  bckColor: Colors.green,
                                                ),
                                            ],
                                          ),
                                          restController.isOpenNow(
                                                  _restaurantList[index])
                                              ? SizedBox()
                                              : NotAvailableWidget(
                                                  isRestaurant: true,
                                                ),
                                          Positioned(
                                            top: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                            right: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                            child:
                                                GetBuilder<WishListController>(
                                              builder: (wishController) {
                                                bool _isWished = wishController
                                                    .wishRestIdList
                                                    .contains(
                                                  _restaurantList[index].id,
                                                );
                                                return InkWell(
                                                  onTap: () {
                                                    if (Get.find<
                                                            AuthController>()
                                                        .isLoggedIn()) {
                                                      _isWished
                                                          ? wishController
                                                              .removeFromWishList(
                                                              _restaurantList[
                                                                      index]
                                                                  .id,
                                                              true,
                                                            )
                                                          : wishController
                                                              .addToWishList(
                                                              null,
                                                              _restaurantList[
                                                                  index],
                                                              true,
                                                            );
                                                    } else {
                                                      showCustomSnackBar(
                                                        'you_are_not_logged_in'
                                                            .tr,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                      Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        Dimensions.RADIUS_SMALL,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      _isWished
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      size: 15,
                                                      color: _isWished
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .disabledColor,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _restaurantList[index].name,
                                                style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Text(
                                                _restaurantList[index].address,
                                                style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              RatingBar(
                                                rating: _restaurantList[index]
                                                    .avgRating,
                                                ratingCount:
                                                    _restaurantList[index]
                                                        .ratingCount,
                                                size: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : PopularRestaurantShimmer(
                            restController: restController,
                          ),
                  ),
                ),
              ],
            );
    });
  }
}

class PopularRestaurantShimmer extends StatelessWidget {
  final RestaurantController restController;
  PopularRestaurantShimmer({@required this.restController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 150,
          width: 200,
          margin:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                BoxShadow(
                  color: Colors
                      .grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                      Dimensions.RADIUS_SMALL,
                    )),
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 100,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 10,
                            width: 130,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300],
                          ),
                          SizedBox(height: 5),
                          RatingBar(
                            rating: 0.0,
                            size: 12,
                            ratingCount: 0,
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
