import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/checkout_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'discount_tag.dart';

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool showCheckoutBtn;
  final bool inRestaurantPage;
  final bool isUpdate;

  ProductBottomSheet({
    @required this.product,
    this.isCampaign = false,
    this.cart,
    this.cartIndex,
    this.inRestaurantPage = false,
    this.showCheckoutBtn = true,
    this.isUpdate = false,
  });

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  @override
  void initState() {
    super.initState();
    Get.find<ProductController>().initData(widget.product, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    double topRadius = 22;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: ResponsiveHelper.isMobile(context)
            ? BorderRadius.vertical(
                top: Radius.circular(
                  topRadius,
                ),
              )
            : BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_EXTRA_LARGE,
                ),
              ),
      ),
      child: GetBuilder<RestaurantController>(builder: (restaurantController) {
        return GetBuilder<ProductController>(builder: (productController) {
          List<String> _variationList = [];
          for (int index = 0;
              index < widget.product.choiceOptions.length;
              index++) {
            if (widget.product.choiceOptions != null &&
                widget.product.choiceOptions.length > 0) {
              if (widget.product.choiceOptions[index].options != null &&
                  widget.product.choiceOptions[index].options.length > 0) {
                if (productController.variationIndex != null &&
                    productController.variationIndex.length > index) {
                  _variationList.add(
                    widget.product.choiceOptions[index]
                        .options[productController.variationIndex[index]]
                        .replaceAll(' ', ''),
                  );
                }
              }
            }
          }
          String variationType = '';
          bool isFirst = true;
          _variationList.forEach((variation) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          });

          Restaurant _restaurant;
          if (restaurantController.restaurantModel.restaurants != null &&
              restaurantController.restaurantModel.restaurants.isNotEmpty) {
            restaurantController.restaurantModel.restaurants.forEach((element) {
              if (element.id == widget.product.restaurantId) {
                _restaurant = element.copyWith();
              }
            });
          }

          double price = widget.product.price;
          double _discount =
              (widget.isCampaign || widget.product.restaurantDiscount == 0)
                  ? widget.product.discount
                  : widget.product.restaurantDiscount;
          String _discountType =
              (widget.isCampaign || widget.product.restaurantDiscount == 0)
                  ? widget.product.discountType
                  : 'percent';
          double priceWithDiscount = PriceConverter.convertWithDiscount(
            price,
            _discount,
            _discountType,
          );
          double priceWithQuantity =
              priceWithDiscount * productController.quantity;
          double addonsCost = 0;
          List<AddOn> _addOnIdList = [];
          List<AddOns> _addOnsList = [];
          for (int index = 0; index < widget.product.addOns.length; index++) {
            if (productController.addOnActiveList[index]) {
              addonsCost = addonsCost +
                  (widget.product.addOns[index].price *
                      productController.addOnQtyList[index]);
              _addOnIdList.add(
                AddOn(
                  id: widget.product.addOns[index].id,
                  quantity: productController.addOnQtyList[index],
                ),
              );
              _addOnsList.add(
                widget.product.addOns[index],
              );
            }
          }
          double priceWithAddons = priceWithQuantity + addonsCost;
          bool _isAvailable = DateConverter.isAvailable(
              widget.product.availableTimeStarts,
              widget.product.availableTimeEnds);

          CartModel _cartModel = CartModel(
            price,
            priceWithDiscount,
            [],
            (price -
                PriceConverter.convertWithDiscount(
                    price, _discount, _discountType)),
            productController.quantity,
            _addOnIdList,
            _addOnsList,
            widget.isCampaign,
            widget.product,
          );
          double screenHeight = MediaQuery.of(context).size.height;

          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.3,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: Icon(
                                Icons.close,
                                size: 26,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(topRadius),
                      topLeft: Radius.circular(topRadius),
                    ),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 240,
                                child:
                                    (widget.product.image != null &&
                                            widget.product.image.isNotEmpty)
                                        ? InkWell(
                                            onTap: widget.isCampaign
                                                ? null
                                                : () {
                                                    if (!widget.isCampaign) {
                                                      Get.toNamed(
                                                        RouteHelper
                                                            .getItemImagesRoute(
                                                          widget.product,
                                                        ),
                                                      );
                                                    }
                                                  },
                                            child: Stack(
                                              children: [
                                                CustomImage(
                                                  image:
                                                      '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                                                  width: double.infinity,
                                                  height: 240,
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 240,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 4.0,
                                                    left: 4,
                                                    right: 6,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          if (widget.product
                                                                  .discount !=
                                                              null)
                                                            DiscountTag(
                                                              discount:
                                                                  _discount,
                                                              discountType:
                                                                  _discountType,
                                                            ),
                                                          Spacer(),
                                                          widget.isCampaign
                                                              ? SizedBox()
                                                              : Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 12,
                                                                    ),
                                                                    GetBuilder<
                                                                            WishListController>(
                                                                        builder:
                                                                            (wishList) {
                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (Get.find<AuthController>()
                                                                              .isLoggedIn()) {
                                                                            wishList.wishProductIdList.contains(widget.product.id)
                                                                                ? wishList.removeFromWishList(
                                                                                    widget.product.id,
                                                                                    false,
                                                                                  )
                                                                                : wishList.addToWishList(
                                                                                    widget.product,
                                                                                    null,
                                                                                    false,
                                                                                  );
                                                                          } else {
                                                                            showCustomSnackBar(
                                                                              'you_are_not_logged_in'.tr,
                                                                            );
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              36,
                                                                          height:
                                                                              36,
                                                                          margin:
                                                                              EdgeInsets.only(
                                                                            top:
                                                                                8,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Theme.of(context).disabledColor.withOpacity(0.3),
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(6),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.favorite,
                                                                            size:
                                                                                28,
                                                                            color: wishList.wishProductIdList.contains(
                                                                              widget.product.id,
                                                                            )
                                                                                ? Theme.of(context).primaryColor
                                                                                : Theme.of(context).disabledColor,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                                    SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      child: Text(
                                        widget.product.name,
                                        style: robotoBold.copyWith(
                                          fontSize: 19,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              widget.product.restaurantName,
                                              style: robotoMedium.copyWith(
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.95),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            RatingBar(
                                              rating: widget.product.avgRating,
                                              size: 15,
                                              ratingCount:
                                                  widget.product.ratingCount,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .disabledColor
                                                .withOpacity(0.4),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                              horizontal: 6,
                                            ),
                                            child: Text(
                                              '\$${widget.product.price}',
                                              style: robotoMedium.copyWith(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (widget.product.description != null &&
                                        widget.product.description.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          widget.product.description,
                                          style: robotoRegular.copyWith(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${'Quantity'.tr}',
                                          style: robotoMedium.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Spacer(),
                                        QuantityButton(
                                          onTap: () {
                                            if (productController.quantity >
                                                1) {
                                              productController
                                                  .setQuantity(false);
                                            }
                                          },
                                          isIncrement: false,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                          ),
                                          child: Text(
                                            productController.quantity
                                                .toString(),
                                            style: robotoMedium.copyWith(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        QuantityButton(
                                          onTap: () => productController
                                              .setQuantity(true),
                                          isIncrement: true,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                        top: 18,
                                        left: 6,
                                        right: 6,
                                      ),
                                      child: DottedLine(
                                        dashColor:
                                            Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    // Addons
                                    widget.product.addOns.length > 0
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'addons'.tr,
                                                style: robotoMedium,
                                              ),
                                              SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 20,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio:
                                                        (1 / 0.84),
                                                  ),
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: widget
                                                      .product.addOns.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        if (!productController
                                                                .addOnActiveList[
                                                            index]) {
                                                          productController
                                                              .addAddOn(
                                                                  true, index);
                                                        } else if (productController
                                                                    .addOnQtyList[
                                                                index] ==
                                                            1) {
                                                          productController
                                                              .addAddOn(
                                                                  false, index);
                                                        }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                          bottom: productController
                                                                      .addOnActiveList[
                                                                  index]
                                                              ? 2
                                                              : 20,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: productController
                                                                      .addOnActiveList[
                                                                  index]
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .backgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            Dimensions
                                                                .RADIUS_SMALL,
                                                          ),
                                                          border: productController
                                                                      .addOnActiveList[
                                                                  index]
                                                              ? null
                                                              : Border.all(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                  width: 2,
                                                                ),
                                                          boxShadow:
                                                              productController
                                                                          .addOnActiveList[
                                                                      index]
                                                                  ? [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey[Get
                                                                                .isDarkMode
                                                                            ? 700
                                                                            : 300],
                                                                        blurRadius:
                                                                            5,
                                                                        spreadRadius:
                                                                            1,
                                                                      )
                                                                    ]
                                                                  : null,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      widget
                                                                          .product
                                                                          .addOns[
                                                                              index]
                                                                          .name,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: robotoMedium
                                                                          .copyWith(
                                                                        color: productController.addOnActiveList[index]
                                                                            ? Colors.white
                                                                            : greenDark,
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      widget.product.addOns[index].price >
                                                                              0
                                                                          ? PriceConverter.convertPrice(widget
                                                                              .product
                                                                              .addOns[index]
                                                                              .price)
                                                                          : 'free'.tr,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: robotoMedium
                                                                          .copyWith(
                                                                        color: productController.addOnActiveList[index]
                                                                            ? Colors.white
                                                                            : yellowDark,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            productController
                                                                        .addOnActiveList[
                                                                    index]
                                                                ? Container(
                                                                    height: 25,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(Dimensions
                                                                                .RADIUS_SMALL),
                                                                        color: Theme.of(context)
                                                                            .cardColor),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (productController.addOnQtyList[index] > 1) {
                                                                                productController.setAddOnQuantity(false, index);
                                                                              } else {
                                                                                productController.addAddOn(false, index);
                                                                              }
                                                                            },
                                                                            child:
                                                                                Center(child: Icon(Icons.remove, size: 15)),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          productController
                                                                              .addOnQtyList[index]
                                                                              .toString(),
                                                                          style:
                                                                              robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              InkWell(
                                                                            onTap: () =>
                                                                                productController.setAddOnQuantity(true, index),
                                                                            child:
                                                                                Center(
                                                                              child: Icon(
                                                                                Icons.add,
                                                                                size: 15,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                    if (widget.product.addOns.length > 0)
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                          left: 6,
                                          right: 6,
                                        ),
                                        child: DottedLine(
                                          dashColor:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),

                                    Row(
                                      children: [
                                        Text(
                                          '${'total_amount'.tr}:',
                                          style: robotoMedium,
                                        ),
                                        Spacer(),
                                        Text(
                                          PriceConverter.convertPrice(
                                              priceWithAddons),
                                          style: robotoBold.copyWith(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE),

                                    _isAvailable
                                        ? SizedBox()
                                        : Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            margin: EdgeInsets.only(
                                              bottom:
                                                  Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL,
                                              ),
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                            ),
                                            child: Column(children: [
                                              Text(
                                                'not_available_now'.tr,
                                                style: robotoMedium.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                ),
                                              ),
                                              Text(
                                                '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts)} '
                                                '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds)}',
                                                style: robotoRegular,
                                              ),
                                            ]),
                                          ),

                                    (!widget.product.scheduleOrder &&
                                            !_isAvailable)
                                        ? SizedBox()
                                        : Row(children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(50, 50), backgroundColor: Theme.of(context).cardColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Dimensions.RADIUS_SMALL,
                                                  ),
                                                  side: BorderSide(
                                                    width: 2,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (widget.inRestaurantPage) {
                                                  Get.back();
                                                } else {
                                                  Get.offNamed(
                                                    RouteHelper
                                                        .getRestaurantRoute(
                                                      _restaurant.id,
                                                    ),
                                                    arguments: RestaurantScreen(
                                                      restaurant: _restaurant,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Image.asset(
                                                'assets/image/ic_venues_blue.png',
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 30,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            Expanded(
                                              child: CustomButton(
                                                width:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.0
                                                        : null,
                                                /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                                ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                                                buttonText: widget.isCampaign
                                                    ? 'order_now'.tr
                                                    : widget.isUpdate
                                                        ? 'update_in_cart'.tr
                                                        : 'add_to_cart'.tr,
                                                onPressed: () {
                                                  Get.back();
                                                  if (widget.isCampaign) {
                                                    if (widget
                                                        .showCheckoutBtn) {
                                                      Get.toNamed(
                                                        RouteHelper
                                                            .getCheckoutRoute(
                                                                'campaign', 1),
                                                        arguments:
                                                            CheckoutScreen(
                                                          fromCart: false,
                                                          cartList: [
                                                            _cartModel
                                                          ],
                                                          orderType: 1,
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    if (Get.find<
                                                            CartController>()
                                                        .existAnotherRestaurantProduct(
                                                      _cartModel
                                                          .product.restaurantId,
                                                    )) {
                                                      Get.dialog(
                                                        ConfirmationDialog(
                                                          icon: Images.warning,
                                                          title:
                                                              'are_you_sure_to_reset'
                                                                  .tr,
                                                          description:
                                                              'if_you_continue'
                                                                  .tr,
                                                          onYesPressed: () {
                                                            Get.back();
                                                            Get.find<
                                                                    CartController>()
                                                                .removeAllAndAddToCart(
                                                              _cartModel,
                                                            );
                                                            _showCartSnackBar(
                                                              widget
                                                                  .showCheckoutBtn,
                                                            );
                                                          },
                                                        ),
                                                        barrierDismissible:
                                                            false,
                                                      );
                                                    } else {
                                                      if (widget.isUpdate) {
                                                        Get.find<
                                                                CartController>()
                                                            .updateToCart(
                                                          _cartModel,
                                                          widget.cartIndex !=
                                                                  null
                                                              ? widget.cartIndex
                                                              : productController
                                                                  .cartIndex,
                                                        );
                                                        _showCartSnackBar(
                                                          widget
                                                              .showCheckoutBtn,
                                                        );
                                                      } else {
                                                        Get.find<
                                                                CartController>()
                                                            .addToCart(
                                                          _cartModel,
                                                          widget.cartIndex !=
                                                                  null
                                                              ? widget.cartIndex
                                                              : productController
                                                                  .cartIndex,
                                                        );
                                                        _showCartSnackBar(
                                                          widget
                                                              .showCheckoutBtn,
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ]),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }

  void _showCartSnackBar(bool showCheckOutBtn) {
    print('=== viewCart.showCheckoutBtn: $showCheckOutBtn');
    ScaffoldMessenger.of(Get.context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        action: SnackBarAction(
            label: 'view_cart'.tr,
            textColor: Colors.white,
            onPressed: () {
              if (showCheckOutBtn) {
                Get.toNamed(
                  RouteHelper.getCartRoute(),
                );
              } else {
                Get.toNamed(
                  RouteHelper.getReserveCart(),
                );
              }
            }),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        ),
        content: Text(
          'item_added_to_cart'.tr,
          style: robotoMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
