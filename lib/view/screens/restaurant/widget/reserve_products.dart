import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReserveProducts extends StatefulWidget {
  final Function onClickNext;
  const ReserveProducts({
    Key key,
    this.onClickNext,
  }) : super(key: key);
  @override
  State<ReserveProducts> createState() => _ReserveProductsState();
}

class _ReserveProductsState extends State<ReserveProducts> {
  @override
  Widget build(BuildContext context) {
    const double mariHorPadding = 16;
    return GetBuilder<VendorController>(builder: (vendorController) {
      return GetBuilder<RestaurantController>(builder: (restaurantController) {
        List<Product> _productList = [];
        if (restaurantController.categoryList.length > 0) {
          if (restaurantController.restaurantProducts != null) {
            if (restaurantController.categoryIndex == 0) {
              if (restaurantController.restaurantProducts != null) {
                _productList.addAll(restaurantController.restaurantProducts);
              }
            } else {
              if (restaurantController.restaurantProducts != null) {
                restaurantController.restaurantProducts.forEach((product) {
                  if (product.categoryId ==
                      restaurantController
                          .categoryList[restaurantController.categoryIndex]
                          .id) {
                    _productList.add(product);
                  }
                });
              }
            }
          }
        }
        return Padding(
          padding: const EdgeInsets.all(mariHorPadding - 2),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                child: (restaurantController.categoryList.length > 0)
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurantController.categoryList.length,
                        padding: EdgeInsets.only(
                          left: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () =>
                                restaurantController.setCategoryIndex(index),
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
                                      restaurantController
                                          .categoryList[index].name,
                                      style: index ==
                                              restaurantController.categoryIndex
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
                                  index == restaurantController.categoryIndex
                                      ? Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
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
              Padding(
                padding: EdgeInsets.only(
                  bottom: 6,
                  top: 4,
                ),
                child: ProductView(
                  isRestaurant: false,
                  restaurants: null,
                  products: _productList,
                  inRestaurantPage: true,
                  type: restaurantController.type,
                  showCheckoutBtn: false,
                  onVegFilterTap: (String type) {
                    restaurantController.getRestaurantProductList(
                      restaurantController.restaurant.id,
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
              InkWell(
                onTap: () async {
                  if (Get.find<CartController>().cartList.isNotEmpty) {
                    widget.onClickNext();
                  } else {
                    showCustomSnackBar(
                      'Please select some foods.'.tr,
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 44,
                  margin: EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      'Continue'.tr,
                      style: robotoMedium.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
