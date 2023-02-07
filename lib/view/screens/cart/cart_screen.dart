import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/cart/widget/cart_product_widget.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  final fromNav;

  CartScreen({
    @required this.fromNav,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'my_cart'.tr,
        isBackButtonExist:
            (ResponsiveHelper.isDesktop(context) || !widget.fromNav),
      ),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          var venueName = '';
          List<List<AddOns>> _addOnsList = [];
          List<bool> _availableList = [];
          double _itemPrice = 0;
          double _addOns = 0;
          cartController.cartList.forEach((cartModel) {
            venueName = cartModel.product.restaurantName;
            List<AddOns> _addOnList = [];
            cartModel.addOnIds.forEach((addOnId) {
              for (AddOns addOns in cartModel.product.addOns) {
                if (addOns.id == addOnId.id) {
                  _addOnList.add(addOns);
                  break;
                }
              }
            });
            _addOnsList.add(_addOnList);
            _availableList.add(
              DateConverter.isAvailable(
                cartModel.product.availableTimeStarts,
                cartModel.product.availableTimeEnds,
              ),
            );

            for (int index = 0; index < _addOnList.length; index++) {
              _addOns = _addOns +
                  (_addOnList[index].price *
                      cartModel.addOnIds[index].quantity);
            }
            _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
          });
          double _subTotal = _itemPrice + _addOns;

          return cartController.cartList.length > 0
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '$venueName',
                                        style: robotoMedium.copyWith(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Spacer(),
                                      Badge(
                                        label: Text(
                                          '${cartController.cartList != null && cartController.cartList.isNotEmpty ? cartController.cartList.length : 0}',
                                          style: robotoRegular.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/image/ic_cart.png',
                                          width: 24,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  // Product
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cartController.cartList.length,
                                    itemBuilder: (context, index) {
                                      return CartProductWidget(
                                        cart: cartController.cartList[index],
                                        cartIndex: index,
                                        addOns: _addOnsList[index],
                                        isAvailable: _availableList[index],
                                        showCheckoutBtn: true,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_SMALL),

                                  // Total
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('item_price'.tr,
                                            style: robotoRegular),
                                        Text(
                                            PriceConverter.convertPrice(
                                                _itemPrice),
                                            style: robotoRegular),
                                      ]),
                                  SizedBox(height: 10),

                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'addons'.tr,
                                          style: robotoRegular,
                                        ),
                                        Text(
                                          '(+) ${PriceConverter.convertPrice(_addOns)}',
                                          style: robotoRegular,
                                        ),
                                      ]),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    child: Divider(
                                      thickness: 1,
                                      color: Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.5),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'subtotal'.tr,
                                        style: robotoMedium,
                                      ),
                                      Text(
                                        PriceConverter.convertPrice(_subTotal),
                                        style: robotoMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.all(
                        Dimensions.PADDING_SIZE_SMALL,
                      ),
                      margin: EdgeInsets.only(
                        bottom: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      child: CustomButton(
                          buttonText: 'proceed_to_checkout'.tr,
                          onPressed: () {
                            if (!cartController
                                    .cartList.first.product.scheduleOrder &&
                                _availableList.contains(false)) {
                              showCustomSnackBar(
                                'one_or_more_product_unavailable'.tr,
                              );
                            } else {
                              if (Get.find<LocationController>().addressList ==
                                      null ||
                                  Get.find<LocationController>()
                                      .addressList
                                      .isEmpty) {
                                showCustomSnackBar(
                                  'Please add address first.'.tr,
                                  isError: false,
                                );
                                _checkPermission(() {
                                  Get.toNamed(
                                    RouteHelper.getAddressInfoRoute(),
                                  );
                                });
                              } else {
                                Get.bottomSheet(
                                  SelectOrderTypeDlgContent(
                                    onClickOk: (orderIndex) {
                                      Get.back();
                                      print('=== orderIndex: $orderIndex');
                                      if(orderIndex < 2){
                                        Get.find<OrderController>().setOrderType(orderIndex == 0 ? 'delivery' : 'take_away');
                                        Get.find<CouponController>()
                                            .removeCouponData(false);
                                        Get.toNamed(
                                          RouteHelper.getCheckoutRoute('cart', orderIndex),
                                        );
                                      }
                                    },
                                    onClickCancel: () {
                                      Get.back();
                                    },
                                  ),
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: false,
                                );
                              }
                            }
                          }),
                    ),
                  ],
                )
              : NoDataScreen(
                  isCart: true,
                  text: '',
                );
        },
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    } else {
      onTap();
    }
  }
}

class SelectOrderTypeDlgContent extends StatefulWidget {
  final Function onClickCancel;
  final Function onClickOk;

  const SelectOrderTypeDlgContent({
    Key key,
    this.onClickOk,
    this.onClickCancel,
  }) : super(key: key);

  @override
  State<SelectOrderTypeDlgContent> createState() =>
      _SelectOrderTypeDlgContentState();
}

class _SelectOrderTypeDlgContentState extends State<SelectOrderTypeDlgContent> {
  var orderType = 0;

  var typeTitles = {
    'Delivery'.tr,
    'Pick-Up'.tr,
    'Dine-In'.tr,
    'Table Service'.tr,
  };

  var assetTitles = {
    'assets/image/ic_delivery_black.png',
    'assets/image/ic_blubs.png',
    'assets/image/ic_denein.png',
    'assets/image/ic_table_services.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.WEB_MAX_WIDTH,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 26,
          ),
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Image.asset(
                'assets/image/ic_table_services.png',
                width: 22,
                fit: BoxFit.fitWidth,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                '${'PLease choose your order type'.tr}',
                style: robotoMedium.copyWith(
                  fontSize: 16,
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          for (int i = 0; i < 4; i++)
            InkWell(
              onTap: () {
                setState(() {
                  orderType = i;
                  print('=== i: $i, orderType: $orderType');
                });
              },
              child: Container(
                width: double.infinity,
                height: 48,
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                color: Colors.grey.withOpacity(0.3),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(
                          width: 1,
                          color: orderType == i
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: orderType == i
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Image.asset(
                      '${assetTitles.elementAt(i)}',
                      width: 20,
                      fit: BoxFit.fitWidth,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          '${typeTitles.elementAt(i)}',
                          style: robotoRegular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    widget.onClickCancel();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${'No'.tr}',
                        style: robotoMedium.copyWith(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.onClickOk(orderType);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${'Okay'.tr}',
                        style: robotoMedium.copyWith(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
