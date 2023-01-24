import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/featured_tag.dart';
import 'package:efood_multivendor/view/base/rating_simplified.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/fav_foods_view.dart';

class FavFoodsScreen extends StatelessWidget {
  final int index;
  FavFoodsScreen({@required this.index});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    var imgUrlPrefix = '${_baseUrls.productImageUrl}/';
    return Scaffold(
      body: GetBuilder<ProductController>(builder: (productController) {
        return GetBuilder<WishListController>(builder: (wishController) {
          List<Product> featuredProducts = [];
          List<Product> favoriteProducts = [];
          print('=== productList: ${productController.productList.length}');
          if (productController.productList != null &&
              productController.productList.isNotEmpty) {
            productController.productList.forEach((product) {
              if (product.featured == 1) {
                featuredProducts.add(product);
              }
            });
          }
          if (wishController.wishProductList != null &&
              wishController.wishProductList.isNotEmpty) {
            wishController.wishProductList.forEach((product) {
              if (product.featured == 1) {
                favoriteProducts.add(product);
              }
            });
          }
          return RefreshIndicator(
            onRefresh: () async {
              await wishController.getWishList();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (featuredProducts.isNotEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: Dimensions.HEIGHT_OF_CHEF_CELL + 32,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Featured Products'.tr,
                              style: robotoMedium.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                key: UniqueKey(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: featuredProducts.length,
                                itemBuilder: (context, index) {
                                  double __cellWidth =
                                      MediaQuery.of(context).size.width * 0.92;
                                  return Container(
                                    width: __cellWidth,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: __cellWidth,
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[
                                                    Get.isDarkMode ? 700 : 300],
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                child: CustomImage(
                                                  image:
                                                      '$imgUrlPrefix${featuredProducts[index].image}',
                                                  width: __cellWidth,
                                                  height: 164,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 12),
                                                    Text(
                                                      '${featuredProducts[index].name}',
                                                      style:
                                                          robotoMedium.copyWith(
                                                        fontSize: 16,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          featuredProducts[
                                                                      index]
                                                                  .restaurantName ??
                                                              '',
                                                          style: robotoRegular
                                                              .copyWith(
                                                            fontSize: 12,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Spacer(),
                                                        RatingSimplified(
                                                          rating:
                                                              featuredProducts[
                                                                      index]
                                                                  .avgRating,
                                                          size: 14,
                                                          ratingCount:
                                                              featuredProducts[
                                                                      index]
                                                                  .ratingCount,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: __cellWidth,
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 2,
                                                ),
                                                child: FeaturedTag(
                                                  fontSize: 16,
                                                  style: 1,
                                                ),
                                              ),
                                              if (featuredProducts[index]
                                                          .discount !=
                                                      null &&
                                                  featuredProducts[index]
                                                          .discount >
                                                      0)
                                                DiscountTag(
                                                  discount:
                                                      featuredProducts[index]
                                                          .discount,
                                                  discountType:
                                                      featuredProducts[index]
                                                          .discountType,
                                                ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (favoriteProducts.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Theme.of(context).cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'Favorite Products'.tr,
                              style: robotoMedium.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            width: Dimensions.WEB_MAX_WIDTH,
                            margin: EdgeInsets.only(top: 12),
                            child: FavoriteFoodsView(
                              products: wishController.wishProductList,
                              noDataText: 'no_wish_data_found'.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
