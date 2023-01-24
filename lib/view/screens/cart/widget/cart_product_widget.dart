import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  final bool showCheckoutBtn;
  CartProductWidget({
    @required this.cart,
    @required this.cartIndex,
    @required this.isAvailable,
    @required this.addOns,
    this.showCheckoutBtn = true,
  });

  @override
  Widget build(BuildContext context) {
    double cartPrice = cart.product.price * cart.quantity;
    String itemPrice =
        '\$${(cart.product.price * cart.quantity).toStringAsFixed(2)}';
    String _addOnText = '';
    int _index = 0;
    List<int> _ids = [];
    List<int> _qtys = [];
    cart.addOnIds.forEach((addOn) {
      _ids.add(addOn.id);
      _qtys.add(addOn.quantity);
    });
    cart.product.addOns.forEach((addOn) {
      if (_ids.contains(addOn.id)) {
        _addOnText = _addOnText +
            '${(_index == 0) ? '' : '\n'}${addOn.name} (${_qtys[_index]} x \$${addOn.price})';
        cartPrice += addOn.price * _qtys[_index];
        _index = _index + 1;
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        bottom: Dimensions.PADDING_SIZE_DEFAULT,
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
            Dimensions.RADIUS_SMALL,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[Get.isDarkMode ? 800 : 200],
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          children: [
            Row(children: [
              (cart.product.image != null && cart.product.image.isNotEmpty)
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimensions.RADIUS_SMALL,
                          ),
                          child: CustomImage(
                            image:
                                '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${cart.product.image}',
                            height: 65,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        isAvailable
                            ? SizedBox()
                            : Positioned(
                                top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL,
                                    ),
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: Text(
                                    'not_available_now_break'.tr,
                                    textAlign: TextAlign.center,
                                    style: robotoRegular.copyWith(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                width: Dimensions.PADDING_SIZE_SMALL,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cart.product.name,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      RatingBar(
                        rating: cart.product.avgRating,
                        size: 12,
                        ratingCount: cart.product.ratingCount,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '\$${(cart.discountedPrice + cart.discountAmount).toStringAsFixed(2)}',
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ]),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      QuantityButton(
                        onTap: () {
                          if (cart.quantity > 1) {
                            Get.find<CartController>().setQuantity(false, cart);
                          } else {
                            Get.find<CartController>()
                                .removeFromCart(cartIndex);
                          }
                        },
                        isIncrement: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          cart.quantity.toString(),
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge,
                          ),
                        ),
                      ),
                      QuantityButton(
                        onTap: () =>
                            Get.find<CartController>().setQuantity(true, cart),
                        isIncrement: true,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                      top: 15,
                    ),
                    child: Text(
                      '$itemPrice',
                      style: robotoMedium.copyWith(
                        fontSize: 16,
                        color: yellowDark,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              !ResponsiveHelper.isMobile(context)
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.find<CartController>().removeFromCart(cartIndex);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    )
                  : SizedBox(),
            ]),
            _addOnText.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 6,
                          right: 6,
                          top: 14,
                        ),
                        child: DottedLine(
                          dashColor: Theme.of(context).disabledColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 6,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'addons'.tr}: ',
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                            SizedBox(width: 26),
                            Flexible(
                              child: Text(
                                _addOnText,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                bottom: 6,
                left: 6,
                right: 6,
                top: 14,
              ),
              child: DottedLine(
                dashColor: Theme.of(context).disabledColor,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '\$${cartPrice.toStringAsFixed(2)}',
                    style: robotoMedium,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    ResponsiveHelper.isMobile(context)
                        ? showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (con) => ProductBottomSheet(
                              product: cart.product,
                              cartIndex: cartIndex,
                              cart: cart,
                              showCheckoutBtn: showCheckoutBtn,
                              isUpdate: true,
                            ),
                          )
                        : showDialog(
                            context: context,
                            builder: (con) => Dialog(
                              child: ProductBottomSheet(
                                product: cart.product,
                                cartIndex: cartIndex,
                                cart: cart,
                                showCheckoutBtn: showCheckoutBtn,
                                isUpdate: true,
                              ),
                            ),
                          );
                  },
                  child: Icon(
                    Icons.mode_edit_sharp,
                    color: yellowDark,
                    size: 22,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                InkWell(
                  onTap: () {
                    Get.find<CartController>().removeFromCart(cartIndex);
                  },
                  child: Icon(
                    Icons.delete,
                    color: yellowDark,
                    size: 22,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
