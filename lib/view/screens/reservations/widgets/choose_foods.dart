import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseFoodsScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Function onClickNext;
  const ChooseFoodsScreen({
    Key key,
    this.onClickNext,
    this.restaurant,
  }) : super(key: key);
  @override
  State<ChooseFoodsScreen> createState() => _ChooseFoodsScreenState();
}

class _ChooseFoodsScreenState extends State<ChooseFoodsScreen> {
  var tmpRestaurantId = -1;

  void initProducts() {
    Get.find<RestaurantController>()
        .getRestaurantProductList(widget.restaurant.id, 1, 'all', false);
    tmpRestaurantId = widget.restaurant.id;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tmpRestaurantId != widget.restaurant.id) {
      initProducts();
    }
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      restaurantController.setCategoryList();
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ProductView(
              isRestaurant: false,
              restaurants: null,
              inRestaurantPage: true,
              type: restaurantController.type,
              products: restaurantController.restaurantProducts,
              onVegFilterTap: (String type) {},
              showCheckoutBtn: false,
            ),
            Container(
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
              child: InkWell(
                onTap: () {
                  checkCartModels();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/ic_sandwitch.png',
                      width: 22,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Choose Foods'.tr,
                      style: robotoMedium.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void checkCartModels() {
    if (Get.find<CartController>().cartList.isNotEmpty) {
      widget.onClickNext();
    } else {
      showCustomSnackBar('Please select some foods.'.tr);
    }
  }
}
