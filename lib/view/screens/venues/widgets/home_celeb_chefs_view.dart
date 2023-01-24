import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/celeb_category_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/chefs_another_widget.dart';
import 'package:efood_multivendor/view/base/featured_chefs_widget.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/featured_rentals_logo_widge.dart';
import 'package:efood_multivendor/view/screens/home/widget/home_search_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/main_commission_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCelebChefsView extends StatefulWidget {
  const HomeCelebChefsView({
    Key key,
  }) : super(key: key);
  @override
  _HomeCelebChefsViewState createState() => _HomeCelebChefsViewState();
}

class _HomeCelebChefsViewState extends State<HomeCelebChefsView> {
  List<Vendor> chefsFeatured = [];
  List<Vendor> chefsNew = [];
  List<Vendor> chefsInTabs = [];
  List<CategoryModel> categories = [];
  List<CelebCategoryModel> celebCategories = [];

  var selCatId = 10;
  var searchKey = '';
  var tabIndex = 0;

  initCelebCategories() {
    setState(() {
      celebCategories = [];
      celebCategories.add(new CelebCategoryModel(
          id: 0, name: 'Movie Star', imgAsset: 'assets/image/update.png'));
      celebCategories.add(new CelebCategoryModel(
          id: 1, name: 'Musician', imgAsset: 'assets/image/update.png'));
      celebCategories.add(new CelebCategoryModel(
          id: 2, name: 'Influencer', imgAsset: 'assets/image/update.png'));
      celebCategories.add(new CelebCategoryModel(
          id: 3, name: 'Celebrity Chef', imgAsset: 'assets/image/update.png'));
    });
  }

  @override
  void initState() {
    super.initState();
    initCelebCategories();
  }

  @override
  Widget build(BuildContext context) {
    double tabBtnWidth = (MediaQuery.of(context).size.width - 36) / 4;
    return GetBuilder<RestaurantController>(builder: (restaurantControlelr) {
      return GetBuilder<VendorController>(builder: (vendorController) {
        return GetBuilder<ProductController>(builder: (productController) {
          return GetBuilder<CategoryController>(builder: (categoryController) {
            chefsFeatured = [];
            chefsNew = [];
            chefsInTabs = [];
            categories = [];

            if (restaurantControlelr.restaurantModel != null) {
              if (restaurantControlelr.restaurantModel.restaurants != null) {
                categories.add(new CategoryModel(
                  id: 10,
                  name: 'All',
                  status: 1,
                ));

                if (categoryController.categoryList != null &&
                    categoryController.categoryList.isNotEmpty) {
                  categoryController.categoryList.forEach((category) {
                    categories.add(category);
                  });
                }

                if (vendorController.allVendorList != null &&
                    vendorController.allVendorList.isNotEmpty) {
                  vendorController.allVendorList.forEach((vendor) {
                    if (searchKey == '') {
                      if (tabIndex == 0) {
                        chefsInTabs.add(vendor);
                      } else if (tabIndex == 1) {
                        if (vendor.vFeatured == 1) {
                          chefsInTabs.add(vendor);
                        }
                      } else if (tabIndex == 2) {
                        if (vendor.vTrending == 1) {
                          chefsInTabs.add(vendor);
                        }
                      } else if (tabIndex == 3) {
                        if (vendor.vIsNew == 1) {
                          chefsInTabs.add(vendor);
                        }
                      }
                    } else {
                      if (vendor.fName.toLowerCase().contains(searchKey) ||
                          vendor.lName.toLowerCase().contains(searchKey)) {
                        if (tabIndex == 0) {
                          chefsInTabs.add(vendor);
                        } else if (tabIndex == 1) {
                          if (vendor.vFeatured == 1) {
                            chefsInTabs.add(vendor);
                          }
                        } else if (tabIndex == 2) {
                          if (vendor.vTrending == 1) {
                            chefsInTabs.add(vendor);
                          }
                        } else if (tabIndex == 3) {
                          if (vendor.vIsNew == 1) {
                            chefsInTabs.add(vendor);
                          }
                        }
                      }
                    }
                    var chk = false;
                    if (searchKey == '') {
                      if (selCatId == 10) {
                        chk = true;
                      } else {
                        var venueId = -1;
                        if (restaurantControlelr.restaurantModel.restaurants !=
                                null &&
                            restaurantControlelr
                                .restaurantModel.restaurants.isNotEmpty) {
                          venueId = restaurantControlelr
                              .restaurantModel.restaurants
                              .indexWhere((restaurant) =>
                                  restaurant.vendorId == vendor.id);
                          if (venueId != -1) {
                            var productId = productController.productList
                                .indexWhere((product) =>
                                    product.restaurantId == venueId);
                            if (productId != -1) {
                              if (productController
                                      .productList[productId].categoryId ==
                                  selCatId) {
                                chk = true;
                              } else {
                                productController
                                    .productList[productId].categoryIds
                                    .forEach((element) {
                                  if (int.parse(element.id) == selCatId) {
                                    chk = true;
                                  }
                                });
                              }
                            }
                          }
                        }
                      }
                    } else {
                      if (vendor.fName.toLowerCase().contains(searchKey) ||
                          vendor.lName.toLowerCase().contains(searchKey)) {
                        if (selCatId == 10) {
                          chk = true;
                        } else {
                          var venueId = -1;
                          if (restaurantControlelr
                                      .restaurantModel.restaurants !=
                                  null &&
                              restaurantControlelr
                                  .restaurantModel.restaurants.isNotEmpty) {
                            venueId = restaurantControlelr
                                .restaurantModel.restaurants
                                .indexWhere((restaurant) =>
                                    restaurant.vendorId == vendor.id);
                            if (venueId != -1) {
                              var productId = productController.productList
                                  .indexWhere((product) =>
                                      product.restaurantId == venueId);
                              if (productId != -1) {
                                if (productController
                                        .productList[productId].categoryId ==
                                    selCatId) {
                                  chk = true;
                                } else {
                                  productController
                                      .productList[productId].categoryIds
                                      .forEach((element) {
                                    if (int.parse(element.id) == selCatId) {
                                      chk = true;
                                    }
                                  });
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                    if (chk) {
                      if (vendor.vFeatured == 1) {
                        chefsFeatured.add(vendor);
                      } else if (vendor.vendorType == 1) {
                        chefsNew.add(vendor);
                      } else {
                        chefsNew.add(vendor);
                      }
                    }
                  });
                }
              }
            }
            double catCellWidth = 112;

            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: HomeSearchWidget(
                        searchText: searchKey,
                        hintText: 'Search'.tr,
                        onChangeText: (_text) {
                          print('=== searchText = $_text');
                          setState(() {
                            searchKey = _text;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                categories.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        height: catCellWidth,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: CategoryModel.listUIWidget(
                          categories: categories,
                          height: catCellWidth,
                          selId: selCatId,
                          onClickCell: (_clickId) {
                            setState(() {
                              selCatId = _clickId;
                            });
                          },
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 4,
                ),
                celebCategories.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        height: catCellWidth,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: CelebCategoryModel.cellUI(
                          celebCategories: celebCategories,
                          height: catCellWidth,
                          selId: selCatId,
                          onClickCell: (_clickId) {
                            setState(() {
                              selCatId = _clickId;
                            });
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 2,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        if (chefsFeatured.isNotEmpty)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(2, 4, 2, 6),
                                child: TitleWidget(
                                  title: 'Featured Chefs'.tr,
                                  onTap: () {},
                                ),
                              ),
                              chefsFeatured.length > 0
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: FeaturedChefsWidget(
                                        featuredVendors: chefsFeatured,
                                        restaurants: restaurantControlelr
                                            .restaurantModel.restaurants,
                                        noDataText: 'no_wish_data_found'.tr,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                        if (chefsNew.isNotEmpty)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(2, 16, 2, 6),
                                child: TitleWidget(
                                  title: 'New Chefs'.tr,
                                  onTap: () {},
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: Dimensions.HEIGHT_OF_CHEF_CELL + 52,
                                child: ListView.builder(
                                  key: UniqueKey(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: chefsNew.length,
                                  itemBuilder: (context, index) {
                                    return ChefsAnotherWidget(
                                      vendor: chefsNew[index],
                                      inRestaurant: false,
                                      length: chefsNew.length,
                                      restaurants: restaurantControlelr
                                          .restaurantModel.restaurants,
                                      style: 1,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  color: Theme.of(context).disabledColor.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tabCell(
                          title: 'All'.tr,
                          width: tabBtnWidth,
                          selected: tabIndex == 0,
                          onClickTab: () {
                            setState(() {
                              tabIndex = 0;
                            });
                          },
                        ),
                        tabCell(
                          title: 'Featured'.tr,
                          width: tabBtnWidth,
                          selected: tabIndex == 1,
                          onClickTab: () {
                            setState(() {
                              tabIndex = 1;
                            });
                          },
                        ),
                        tabCell(
                          title: 'Trending'.tr,
                          width: tabBtnWidth,
                          selected: tabIndex == 2,
                          onClickTab: () {
                            setState(() {
                              tabIndex = 2;
                            });
                          },
                        ),
                        tabCell(
                          title: 'New'.tr,
                          width: tabBtnWidth,
                          selected: tabIndex == 3,
                          onClickTab: () {
                            setState(() {
                              tabIndex = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (chefsInTabs.isNotEmpty)
                  for (int i = 0; i < chefsInTabs.length; i++)
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 6,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: Dimensions.HEIGHT_OF_CHEF_CELL + 54,
                      child: ChefsAnotherWidget(
                        vendor: chefsInTabs[i],
                        inRestaurant: false,
                        length: chefsInTabs.length,
                        restaurants:
                            restaurantControlelr.restaurantModel.restaurants,
                        style: 0,
                        wAdjust: 1,
                        tag: tabIndex == 0
                            ? -1
                            : tabIndex == 1
                                ? 0
                                : tabIndex == 2
                                    ? 1
                                    : tabIndex == 3
                                        ? 2
                                        : -1,
                      ),
                    ),
                SizedBox(
                  height: 8,
                ),
                FeaturedRentalsLogoWidge(),
                SizedBox(
                  height: 8,
                ),
                MainCommissionWidget(),
                SizedBox(
                  height: 24,
                ),
              ],
            );
          });
        });
      });
    });
  }

  Widget tabCell({
    String title,
    double width,
    bool selected = false,
    Function onClickTab,
  }) {
    return InkWell(
      onTap: () {
        onClickTab();
      },
      child: selected
          ? Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  6,
                ),
              ),
              child: SizedBox(
                width: width * 0.97,
                height: 36,
                child: Center(
                  child: Text(
                    title,
                    style: robotoMedium.copyWith(
                      fontSize: 12,
                      color: selected
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(
              width: width * 0.97,
              height: 36,
              child: Center(
                child: Text(
                  title,
                  style: robotoMedium.copyWith(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .color
                        .withOpacity(0.7),
                  ),
                ),
              ),
            ),
    );
  }
}
