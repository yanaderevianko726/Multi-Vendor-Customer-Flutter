import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PopularFoodView extends StatelessWidget {
  final bool isPopular;
  PopularFoodView({
    @required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      List<Product> _foodList = [];
      if (isPopular) {
        _foodList = productController.productList;
      } else {
        _foodList = productController.reviewedProductList;
      }
      ScrollController _scrollController = ScrollController();
      return (_foodList != null && _foodList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: TitleWidget(
                    title: 'best_reviewed_food'.tr,
                    onTap: () =>
                        Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: SizedBox(
                    height: Dimensions.HEIGHT_OF_FOOD_CELL,
                    child: _foodList != null
                        ? ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                _foodList.length > 10 ? 10 : _foodList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  ResponsiveHelper.isMobile(context)
                                      ? Get.bottomSheet(
                                          ProductBottomSheet(
                                            product: _foodList[index],
                                            isCampaign: false,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                        )
                                      : Get.dialog(
                                          Dialog(
                                            child: ProductBottomSheet(
                                              product: _foodList[index],
                                            ),
                                          ),
                                        );
                                },
                                child: Container(
                                  width: Dimensions.WIDTH_OF_FOOD_CELL,
                                  height: Dimensions.HEIGHT_OF_FOOD_CELL,
                                  margin: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    right: Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_DEFAULT,
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
                                      SizedBox(
                                        width: Dimensions.WIDTH_OF_FOOD_CELL,
                                        height: Dimensions
                                            .HEIGHT_OF_FOOD_IMAGE_CELL,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimensions.RADIUS_DEFAULT,
                                              ),
                                              child: CustomImage(
                                                image:
                                                    '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                                                    '/${_foodList[index].image}',
                                                width: Dimensions
                                                    .WIDTH_OF_FOOD_CELL,
                                                height: Dimensions
                                                    .HEIGHT_OF_FOOD_IMAGE_CELL,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                DiscountTag(
                                                  discount: 0,
                                                  discountType: '',
                                                  fontSize: 14,
                                                  type: _foodList[index]
                                                              .trending ==
                                                          1
                                                      ? 2
                                                      : _foodList[index]
                                                                  .isNew ==
                                                              1
                                                          ? 3
                                                          : -1,
                                                  bckColor: Colors.green,
                                                ),
                                              ],
                                            ),
                                            productController.isAvailable(
                                              _foodList[index],
                                            )
                                                ? SizedBox()
                                                : NotAvailableWidget(),
                                          ],
                                        ),
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
                                                _foodList[index].name,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RatingBar(
                                                          rating:
                                                              _foodList[index]
                                                                  .avgRating,
                                                          size: 12,
                                                          ratingCount:
                                                              _foodList[index]
                                                                  .ratingCount,
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              PriceConverter
                                                                  .convertPrice(
                                                                productController
                                                                    .getStartingPrice(
                                                                  _foodList[
                                                                      index],
                                                                ),
                                                                discount: _foodList[
                                                                        index]
                                                                    .discount,
                                                                discountType:
                                                                    _foodList[
                                                                            index]
                                                                        .discountType,
                                                              ),
                                                              style: robotoBold
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            SizedBox(
                                                                width: _foodList[index]
                                                                            .discount >
                                                                        0
                                                                    ? Dimensions
                                                                        .PADDING_SIZE_EXTRA_SMALL
                                                                    : 0),
                                                            _foodList[index]
                                                                        .discount >
                                                                    0
                                                                ? Flexible(
                                                                    child: Text(
                                                                    PriceConverter.convertPrice(
                                                                        productController
                                                                            .getStartingPrice(_foodList[index])),
                                                                    style: robotoMedium
                                                                        .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeExtraSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .disabledColor,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                    ),
                                                                  ))
                                                                : SizedBox(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    'assets/image/ic_cart.png',
                                                    width: 20,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ],
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
                        : PopularFoodShimmer(enabled: _foodList == null),
                  ),
                ),
              ],
            );
    });
  }
}

class PopularFoodShimmer extends StatelessWidget {
  final bool enabled;
  PopularFoodShimmer({@required this.enabled});

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
          height: 80,
          width: 200,
          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [
              BoxShadow(
                  color: Colors
                      .grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                  blurRadius: 10,
                  spreadRadius: 1)
            ],
          ),
          child: Shimmer(
            duration: Duration(seconds: 1),
            interval: Duration(seconds: 1),
            enabled: enabled,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15,
                            width: 100,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300]),
                        SizedBox(height: 5),
                        Container(
                            height: 10,
                            width: 130,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300]),
                        SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 10,
                                  width: 30,
                                  color: Colors.grey[
                                      Get.find<ThemeController>().darkTheme
                                          ? 700
                                          : 300]),
                              RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                            ]),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
