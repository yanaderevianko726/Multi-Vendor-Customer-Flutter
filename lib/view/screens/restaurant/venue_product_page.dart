import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenueProductsScreen extends StatefulWidget {
  final String venueId;
  const VenueProductsScreen({
    Key key,
    this.venueId,
  }) : super(key: key);
  @override
  State<VenueProductsScreen> createState() => _VenueProductsScreenState();
}

class _VenueProductsScreenState extends State<VenueProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      print('=== categories: ${restController.categoryList.length}');
      List<Product> _productList = [];
      if (restController.categoryList.length > 0) {
        if (restController.restaurantProducts != null) {
          if (restController.categoryIndex == 0) {
            if (restController.restaurantProducts != null) {
              _productList.addAll(restController.restaurantProducts);
            }
          } else {
            if (restController.restaurantProducts != null) {
              restController.restaurantProducts.forEach((product) {
                if (product.categoryId ==
                    restController
                        .categoryList[restController.categoryIndex].id) {
                  _productList.add(product);
                }
              });
            }
          }
        }
      }

      return Scaffold(
        body: GetBuilder<CartController>(builder: (cartController) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).viewPadding.top + 60,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 200],
                        spreadRadius: 1,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Foods of Venue'.tr,
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: InkWell(
                          onTap: () => Get.toNamed(
                            RouteHelper.getCartRoute(),
                          ),
                          child: Badge(
                            badgeContent: Text(
                              '${cartController.cartList != null && cartController.cartList.isNotEmpty ? cartController.cartList.length : 0}',
                              style: robotoRegular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            child: Image.asset(
                              'assets/image/ic_cart.png',
                              width: 22,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  ),
                  child: (restController.categoryList.length > 0)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restController.categoryList.length,
                          padding: EdgeInsets.only(
                            left: Dimensions.PADDING_SIZE_SMALL,
                          ),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () =>
                                  restController.setCategoryIndex(index),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4.0,
                                      ),
                                      child: Text(
                                        restController.categoryList[index].name,
                                        style: index ==
                                                restController.categoryIndex
                                            ? robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            : robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .color,
                                              ),
                                      ),
                                    ),
                                    index == restController.categoryIndex
                                        ? Container(
                                            height: 5,
                                            width: 5,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : SizedBox(
                                            height: 5,
                                            width: 5,
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : SizedBox(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: mainBgColor,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                              right: 6,
                              bottom: 6,
                              top: 4,
                            ),
                            child: ProductView(
                              isRestaurant: false,
                              restaurants: null,
                              products: _productList,
                              inRestaurantPage: true,
                              type: restController.type,
                              onVegFilterTap: (String type) {
                                restController.getRestaurantProductList(
                                  restController.restaurant.id,
                                  1,
                                  type,
                                  true,
                                );
                              },
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL,
                                vertical: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.PADDING_SIZE_SMALL
                                    : 0,
                              ),
                            ),
                          ),
                          restController.foodPaginate
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
