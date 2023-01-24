import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ConfirmReserveScreen extends StatefulWidget {
  final Restaurant restaurant;
  final String errorMessage;
  final Function onClickNext;
  const ConfirmReserveScreen({
    Key key,
    this.onClickNext,
    this.restaurant,
    this.errorMessage,
  }) : super(key: key);
  @override
  State<ConfirmReserveScreen> createState() => _ConfirmReserveScreenState();
}

class _ConfirmReserveScreenState extends State<ConfirmReserveScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      List<List<AddOns>> _addOnsList = [];
      List<bool> _availableList = [];
      double _itemPrice = 0;
      double _addOns = 0;
      cartController.cartList.forEach((cartModel) {
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
              (_addOnList[index].price * cartModel.addOnIds[index].quantity);
        }
        _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
      });

      Get.find<ReservationController>().setServiceCharges(_itemPrice + _addOns);
      return cartController.cartList != null
          ? cartController.cartList.length > 0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Scrollbar(
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
                                        showCheckoutBtn: false,
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
                                        Text(
                                          'item_price'.tr,
                                          style: robotoRegular,
                                        ),
                                        Text(
                                          '\$${_itemPrice.toStringAsFixed(2)}',
                                          style: robotoRegular,
                                        ),
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
                                          '\$${_addOns.toStringAsFixed(2)}',
                                          style: robotoRegular,
                                        ),
                                      ]),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      bottom: 14,
                                      top: 18,
                                    ),
                                    child: DottedLine(
                                      dashColor:
                                          Theme.of(context).disabledColor,
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
                                        '\$${double.parse((Get.find<ReservationController>().subTotal).toStringAsFixed(2))}',
                                        style: robotoMedium,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${'Server Tip'.tr}',
                                        style: robotoMedium,
                                      ),
                                      Spacer(),
                                      FlutterSwitch(
                                        width: 52.0,
                                        height: 22.0,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        valueFontSize: 12.0,
                                        toggleSize: 44.0,
                                        value: Get.find<ReservationController>()
                                                .serverTipMethod !=
                                            0,
                                        borderRadius: 30.0,
                                        padding: 2,
                                        onToggle: (val) {
                                          if (val) {
                                            Get.find<ReservationController>()
                                                .setServerTipMethod(1);
                                          } else {
                                            Get.find<ReservationController>()
                                                .setServerTipMethod(0);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  if (Get.find<ReservationController>()
                                          .serverTipMethod >
                                      0)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 12,
                                            ),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.find<
                                                            ReservationController>()
                                                        .setServerTipMethod(1);
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Get.find<ReservationController>()
                                                                  .serverTipMethod ==
                                                              1
                                                          ? SizedBox(
                                                              width: 18,
                                                              child: Icon(
                                                                Icons.back_hand,
                                                                size: 18,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.9),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              width: 18,
                                                            ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Get.find<ReservationController>()
                                                                        .serverTipMethod ==
                                                                    1
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.4)
                                                                : null,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  6),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '${'Percentage'.tr}:',
                                                                style:
                                                                    robotoRegular,
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                '(+) ${widget.restaurant.serverTip} %',
                                                                style:
                                                                    robotoRegular,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Get.find<
                                                            ReservationController>()
                                                        .setServerTipMethod(2);
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Get.find<ReservationController>()
                                                                  .serverTipMethod ==
                                                              2
                                                          ? SizedBox(
                                                              width: 18,
                                                              child: Icon(
                                                                Icons.back_hand,
                                                                size: 18,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.7),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              width: 18,
                                                            ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Get.find<ReservationController>()
                                                                        .serverTipMethod ==
                                                                    2
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.4)
                                                                : null,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  6),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '${'Fixed Amount'.tr}:',
                                                                style:
                                                                    robotoRegular,
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                '(+) \$${widget.restaurant.serverTip}',
                                                                style:
                                                                    robotoRegular,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          '${'Server Tip Amount'.tr}:',
                                          style: robotoRegular,
                                        ),
                                        Spacer(),
                                        Text(
                                          '(+) \$${double.parse((Get.find<ReservationController>().serverTipAmount).toStringAsFixed(2))}',
                                          style: robotoRegular,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${'Tax'.tr} (${widget.restaurant.tax}%):',
                                        style: robotoRegular,
                                      ),
                                      Spacer(),
                                      Text(
                                        '(+) \$${double.parse((Get.find<ReservationController>().taxAmount).toStringAsFixed(2))}',
                                        style: robotoRegular,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${'Service Charge'.tr} (${widget.restaurant.serviceCharge}%):',
                                        style: robotoRegular,
                                      ),
                                      Spacer(),
                                      Text(
                                        '(+) \$${double.parse((Get.find<ReservationController>().serviceChargeAmount).toStringAsFixed(2))}',
                                        style: robotoRegular,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${'Promo'.tr} (${widget.restaurant.promo}%):',
                                        style: robotoRegular,
                                      ),
                                      Spacer(),
                                      Text(
                                        '(+) \$${double.parse((Get.find<ReservationController>().promoAmount).toStringAsFixed(2))}',
                                        style: robotoRegular,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      bottom: 14,
                                      top: 18,
                                    ),
                                    child: DottedLine(
                                      dashColor:
                                          Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${'Total Order Amount'}',
                                        style: robotoMedium,
                                      ),
                                      Spacer(),
                                      Text(
                                        '\$${double.parse((Get.find<ReservationController>().total).toStringAsFixed(2))}',
                                        style: robotoMedium,
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 44,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.errorMessage != '')
                        Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              '${widget.errorMessage}',
                              style: robotoRegular.copyWith(
                                fontSize: 16,
                                color: Colors.redAccent.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        height: 44,
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        child: CustomButton(
                            buttonText: 'Confirm & Pay'.tr,
                            onPressed: () {
                              print(
                                  '=== product.scheduleOrder: ${cartController.cartList.first.product.scheduleOrder}');
                              if (!cartController
                                  .cartList.first.product.scheduleOrder) {
                                showCustomSnackBar(
                                  'This restaurant do not provide table service.'
                                      .tr,
                                );
                              } else {
                                widget.onClickNext();
                              }
                            }),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: NoDataScreen(
                    isCart: true,
                    text: '',
                  ),
                )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: NoDataScreen(
                isCart: true,
                text: '',
              ),
            );
    });
  }
}
