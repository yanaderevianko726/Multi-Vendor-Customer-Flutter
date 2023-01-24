import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CuisineProductScreen extends StatefulWidget {
  final String cuisineId;
  final String cuisineName;
  CuisineProductScreen({
    @required this.cuisineId,
    @required this.cuisineName,
  });
  @override
  _CuisineProductScreenState createState() => _CuisineProductScreenState();
}

class _CuisineProductScreenState extends State<CuisineProductScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  TabController _tabController;

  void getProducts() {
    Get.find<ProductController>().getPopularProductList(false, 'all');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return GetBuilder<ProductController>(builder: (productController) {
        return GetBuilder<CuisineController>(builder: (cuisineController) {
          List<Product> _products = [];
          List<Restaurant> _restaurants = [];
          print('=== cProductList: ${productController.productList.length}');
          if (cuisineController.cuisinesList != null &&
              cuisineController.cuisinesList.isNotEmpty) {
            if (Get.find<RestaurantController>().restaurantModel != null &&
                Get.find<RestaurantController>()
                    .restaurantModel
                    .restaurants
                    .isNotEmpty) {
              Get.find<RestaurantController>()
                  .restaurantModel
                  .restaurants
                  .forEach((element) {
                if (element.cuisineId.toString() == widget.cuisineId) {
                  _restaurants.add(element);
                  if (productController.productList != null &&
                      productController.productList.isNotEmpty) {
                    productController.productList.forEach((product) {
                      if (product.restaurantId == element.id) {
                        _products.add(product);
                      }
                    });
                  }
                }
              });
            }
          }

          return Scaffold(
            appBar: ResponsiveHelper.isDesktop(context)
                ? WebMenuBar()
                : AppBar(
                    title: Text(
                      widget.cuisineName,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Theme.of(context).textTheme.bodyText1.color,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    elevation: 0,
                    actions: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: SizedBox(
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
                        ),
                      ),
                    ],
                  ),
            body: Center(
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        color: Theme.of(context).cardColor,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).disabledColor,
                          unselectedLabelStyle: robotoRegular.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: Dimensions.fontSizeSmall),
                          labelStyle: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor),
                          tabs: [
                            Tab(text: 'food'.tr),
                            Tab(text: 'restaurants'.tr),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          return false;
                        },
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: ProductView(
                                  isRestaurant: false,
                                  products: _products,
                                  restaurants: null,
                                  noDataText:
                                      'No food found with this cuisine'.tr,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: SingleChildScrollView(
                                controller: restaurantScrollController,
                                child: ProductView(
                                  isRestaurant: true,
                                  products: null,
                                  restaurants: _restaurants,
                                  noDataText:
                                      'No restaurant found with this cuisine'
                                          .tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
    });
  }
}
