import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReserveFoodsPage extends StatefulWidget {
  final OrderModel orderModel;
  final List<OrderDetailsModel> orderDetailsModel;
  const ReserveFoodsPage({
    Key key,
    this.orderDetailsModel,
    this.orderModel,
  }) : super(key: key);
  @override
  State<ReserveFoodsPage> createState() => _ReserveFoodsPageState();
}

class _ReserveFoodsPageState extends State<ReserveFoodsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      double _itemsPrice = 0;
      double _addOns = 0;
      double _tax = widget.orderModel.restaurant.tax;
      double _serviceCharge = widget.orderModel.restaurant.serviceCharge;
      double _serverTip = widget.orderModel.restaurant.serverTip;
      double _promo = widget.orderModel.restaurant.promo;
      int _serverTipMethod = widget.orderModel.serverTipMethod;

      double _taxAmount = 0.0;
      double _serviceChargeAmount = 0.0;
      double _promoAmount = 0.0;
      double _serverTipAmount = 0;

      if (widget.orderDetailsModel != null) {
        for (OrderDetailsModel orderDetails in widget.orderDetailsModel) {
          for (AddOn addOn in orderDetails.addOns) {
            _addOns = _addOns + (addOn.price * addOn.quantity);
          }
          _itemsPrice =
              _itemsPrice + (orderDetails.price * orderDetails.quantity);
        }
      }
      double _subTotal = _itemsPrice + _addOns;

      if (_tax > 0) {
        _taxAmount = (_subTotal * _tax) / 100;
      }
      if (_serviceCharge > 0) {
        _serviceChargeAmount = (_subTotal * _serviceCharge) / 100;
      }
      if (_promo > 0) {
        _promoAmount = (_subTotal * _promo) / 100;
      }
      if (_serverTip > 0) {
        if (_serverTipMethod == 1) {
          _serverTipAmount = (_subTotal * _serverTip) / 100;
        } else if (_serverTipMethod == 2) {
          _serverTipAmount = _serverTip;
        }
      }

      double _total = _subTotal +
          _taxAmount +
          _serviceChargeAmount +
          _promoAmount +
          _serverTipAmount;
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              if (widget.orderDetailsModel != null)
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                  child: Row(children: [
                                    Text(
                                      '${'Items'.tr}:',
                                      style: robotoMedium,
                                    ),
                                    SizedBox(
                                      width:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    ),
                                    Text(
                                      widget.orderDetailsModel.length
                                          .toString(),
                                      style: robotoMedium.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Expanded(child: SizedBox()),
                                    SizedBox(
                                        width: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    Text(
                                      '\$${_total.toStringAsFixed(2)}',
                                      style: robotoMedium.copyWith(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ]),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                    bottom: 14,
                                    top: 8,
                                  ),
                                  child: DottedLine(
                                    dashColor: Theme.of(context).disabledColor,
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.orderDetailsModel.length,
                                  itemBuilder: (context, index) {
                                    return OrderProductWidget(
                                      order: widget.orderModel,
                                      orderDetails:
                                          widget.orderDetailsModel[index],
                                    );
                                  },
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                    bottom: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.orderDetailsModel == null)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      );
    });
  }
}
