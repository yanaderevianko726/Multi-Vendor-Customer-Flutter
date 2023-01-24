import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/styles.dart';
import '../../../base/cele_chefs_view.dart';

class FavCeleChefsView extends StatelessWidget {
  final int index;
  FavCeleChefsView({
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WishListController>(builder: (wishController) {
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'featured_celebs'.tr,
                    style: robotoMedium.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Dimensions.HEIGHT_OF_CHEF_CELL + 12,
                    child: CeleChefsView(
                      products: wishController.wishProductList,
                      restaurants: Get.find<RestaurantController>()
                          .restaurantModel
                          .restaurants,
                      noDataText: 'no_wish_data_found'.tr,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
