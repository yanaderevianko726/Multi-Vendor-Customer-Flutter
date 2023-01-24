import 'package:carousel_slider/carousel_slider.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ChefsSpecialOffersView.dart';

class BannerView extends StatelessWidget {
  final int pageType;
  const BannerView({
    Key key,
    this.pageType = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorController>(builder: (vendorController) {
      return GetBuilder<RestaurantController>(builder: (restaurantController) {
        return GetBuilder<BannerController>(builder: (bannerController) {
          return (bannerController.bannerImageList != null &&
                  bannerController.bannerImageList.length == 0)
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: Dimensions.HEIGHT_OF_CHEF_CELL + 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 10, 2, 6),
                        child: TitleWidget(
                          title: 'special_offers'.tr,
                          onTap: () {},
                        ),
                      ),
                      if (pageType == 0)
                        Expanded(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              autoPlayInterval: Duration(seconds: 7),
                              onPageChanged: (index, reason) {
                                bannerController.setCurrentIndex(index, true);
                              },
                            ),
                            itemCount:
                                bannerController.bannerImageList.length == 0
                                    ? 1
                                    : bannerController.bannerImageList.length,
                            itemBuilder: (context, index, _) {
                              String _baseUrl =
                                  bannerController.bannerDataList[index]
                                          is BasicCampaignModel
                                      ? Get.find<SplashController>()
                                          .configModel
                                          .baseUrls
                                          .campaignImageUrl
                                      : Get.find<SplashController>()
                                          .configModel
                                          .baseUrls
                                          .bannerImageUrl;
                              return InkWell(
                                onTap: () {
                                  if (bannerController.bannerDataList[index]
                                      is Product) {
                                    Product _product =
                                        bannerController.bannerDataList[index];
                                    ResponsiveHelper.isMobile(context)
                                        ? showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (con) =>
                                                ProductBottomSheet(
                                                    product: _product),
                                          )
                                        : showDialog(
                                            context: context,
                                            builder: (con) => Dialog(
                                                child: ProductBottomSheet(
                                                    product: _product)),
                                          );
                                  } else if (bannerController
                                      .bannerDataList[index] is Restaurant) {
                                    Restaurant _restaurant =
                                        bannerController.bannerDataList[index];
                                    int restaurantId = _restaurant.id;
                                    if (Get.find<RestaurantController>()
                                                .restaurantModel !=
                                            null &&
                                        Get.find<RestaurantController>()
                                            .restaurantModel
                                            .restaurants
                                            .isNotEmpty) {
                                      int ind = Get.find<RestaurantController>()
                                          .restaurantModel
                                          .restaurants
                                          .indexWhere((element) =>
                                              element.id == restaurantId);
                                      if (ind != -1) {
                                        _restaurant =
                                            Get.find<RestaurantController>()
                                                .restaurantModel
                                                .restaurants[ind];
                                        Get.toNamed(
                                          RouteHelper.getRestaurantRoute(
                                            _restaurant.id,
                                          ),
                                          arguments: RestaurantScreen(
                                              restaurant: _restaurant),
                                        );
                                      }
                                    }
                                  } else if (bannerController
                                          .bannerDataList[index]
                                      is BasicCampaignModel) {
                                    BasicCampaignModel _campaign =
                                        bannerController.bannerDataList[index];
                                    Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                            _campaign));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors
                                              .grey[Get.isDarkMode ? 800 : 200],
                                          spreadRadius: 1,
                                          blurRadius: 5)
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    child: GetBuilder<SplashController>(
                                      builder: (splashController) {
                                        return CustomImage(
                                          image:
                                              '$_baseUrl/${bannerController.bannerImageList[index]}',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (pageType == 1)
                        Expanded(
                          child: ListView.builder(
                            key: UniqueKey(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: bannerController.bannerDataList.length,
                            itemBuilder: (context, index) {
                              Widget cell = Container();
                              if (bannerController.bannerDataList[index]
                                  is Product) {
                                var restId = bannerController
                                    .bannerDataList[index].restaurantId;
                                if (vendorController.allVendorList != null &&
                                    vendorController.allVendorList.isNotEmpty) {
                                  var idx = vendorController.allVendorList
                                      .indexWhere((element) =>
                                          element.restaurantId == restId);
                                  if (idx != -1) {
                                    Vendor _vendor = new Vendor();
                                    _vendor =
                                        vendorController.allVendorList[idx];
                                    String _baseUrl =
                                        bannerController.bannerDataList[index]
                                                is BasicCampaignModel
                                            ? Get.find<SplashController>()
                                                .configModel
                                                .baseUrls
                                                .campaignImageUrl
                                            : Get.find<SplashController>()
                                                .configModel
                                                .baseUrls
                                                .bannerImageUrl;
                                    cell = ChefsSpecialOffersView(
                                      vendor: _vendor,
                                      inRestaurant: false,
                                      length: 1,
                                      restaurants: restaurantController
                                          .restaurantModel.restaurants,
                                      imgUrl:
                                          '$_baseUrl/${bannerController.bannerImageList[index]}',
                                      style: 1,
                                    );
                                  }
                                }
                              }
                              return InkWell(
                                onTap: () {
                                  if (bannerController.bannerDataList[index]
                                      is Product) {
                                    Product _product =
                                        bannerController.bannerDataList[index];
                                    ResponsiveHelper.isMobile(context)
                                        ? showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (con) =>
                                                ProductBottomSheet(
                                                    product: _product),
                                          )
                                        : showDialog(
                                            context: context,
                                            builder: (con) => Dialog(
                                                child: ProductBottomSheet(
                                                    product: _product)),
                                          );
                                  } else if (bannerController
                                      .bannerDataList[index] is Restaurant) {
                                    Restaurant _restaurant =
                                        bannerController.bannerDataList[index];
                                    int restaurantId = _restaurant.id;
                                    if (Get.find<RestaurantController>()
                                                .restaurantModel !=
                                            null &&
                                        Get.find<RestaurantController>()
                                            .restaurantModel
                                            .restaurants
                                            .isNotEmpty) {
                                      int ind = Get.find<RestaurantController>()
                                          .restaurantModel
                                          .restaurants
                                          .indexWhere((element) =>
                                              element.id == restaurantId);
                                      if (ind != -1) {
                                        _restaurant =
                                            Get.find<RestaurantController>()
                                                .restaurantModel
                                                .restaurants[ind];
                                        Get.toNamed(
                                          RouteHelper.getRestaurantRoute(
                                            _restaurant.id,
                                          ),
                                          arguments: RestaurantScreen(
                                              restaurant: _restaurant),
                                        );
                                      }
                                    }
                                  } else if (bannerController
                                          .bannerDataList[index]
                                      is BasicCampaignModel) {
                                    BasicCampaignModel _campaign =
                                        bannerController.bannerDataList[index];
                                    Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                            _campaign));
                                  }
                                },
                                child: cell,
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 6),
                      if (pageType == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerController.bannerImageList.map((bnr) {
                            int index =
                                bannerController.bannerImageList.indexOf(bnr);
                            return TabPageSelectorIndicator(
                              backgroundColor:
                                  index == bannerController.currentIndex
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                              borderColor: Theme.of(context).backgroundColor,
                              size: index == bannerController.currentIndex
                                  ? 10
                                  : 7,
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                );
        });
      });
    });
  }
}
