import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/confirm_reserve.dart';
import 'widget/reserve_products.dart';

class MakeReserveAPlaceScreen extends StatefulWidget {
  final Restaurant restaurant;
  const MakeReserveAPlaceScreen({
    Key key,
    this.restaurant,
  }) : super(key: key);
  @override
  State<MakeReserveAPlaceScreen> createState() =>
      _MakeReserveAPlaceScreenState();
}

class _MakeReserveAPlaceScreenState extends State<MakeReserveAPlaceScreen> {
  final FocusNode _placeNameFocus = FocusNode();
  final FocusNode _numberInFocus = FocusNode();
  final FocusNode _specialFocus = FocusNode();
  final TextEditingController _placeNameCtrl = TextEditingController();
  final TextEditingController _numberInCtrl = TextEditingController();
  final TextEditingController _specialCtrl = TextEditingController();

  Vendor vendor;
  var isLoading = false;
  var selStepIndex = 0;
  var strErrorMessage = '';
  var _date = '';
  var _startTime = '';

  void initPageData() {
    _placeNameCtrl.text = '';
    DateTime _curDate = DateTime.now();
    _date =
        '${_curDate.year}-${_curDate.month < 10 ? '0${_curDate.month}' : _curDate.month}-${_curDate.day < 10 ? '0${_curDate.day}' : _curDate.day}';
    _startTime =
        '${_curDate.hour < 10 ? '0${_curDate.hour}' : _curDate.hour}:${_curDate.minute < 10 ? '0${_curDate.minute}' : _curDate.minute}';
    if (mounted) {
      Get.find<ReservationController>()
          .initReserveForPlace(_date, _startTime, widget.restaurant);
      Get.find<RestaurantController>().setCategoryIndex(0, enUpdate: false);
      Get.find<CartController>().clearCartList(enUpdate: false);
      Get.find<OrderController>().setPaymentMethod(1, enUpdate: false);
    }
  }

  @override
  void initState() {
    super.initState();
    initPageData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selStepIndex > 0) {
          setState(() {
            strErrorMessage = '';
            selStepIndex--;
          });
        } else {
          Get.back();
        }
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Reserve A Place'.tr),
        body: GetBuilder<VendorController>(builder: (vendorController) {
          const double mariHorPadding = 16.0;
          double screenWidth = MediaQuery.of(context).size.width;
          return GetBuilder<RestaurantController>(
              builder: (restaurantController) {
            if (Get.find<ReservationController>().reservation == null) {
              initPageData();
            }
            if (mounted) {
              if (vendor == null) {
                if (vendorController.allVendorList != null &&
                    vendorController.allVendorList.isNotEmpty) {
                  vendorController.allVendorList.forEach((__vendor) {
                    if (__vendor.id == widget.restaurant.vendorId) {
                      vendor = __vendor.copyWith();
                      Get.find<ReservationController>().setVendorInfo(vendor);
                    }
                  });
                }
              }
              List<Product> _productList = [];
              if (restaurantController.categoryList.length > 0) {
                if (restaurantController.restaurantProducts != null) {
                  if (restaurantController.categoryIndex == 0) {
                    if (restaurantController.restaurantProducts != null) {
                      _productList
                          .addAll(restaurantController.restaurantProducts);
                    }
                  } else {
                    if (restaurantController.restaurantProducts != null) {
                      restaurantController.restaurantProducts
                          .forEach((product) {
                        if (product.categoryId ==
                            restaurantController
                                .categoryList[
                                    restaurantController.categoryIndex]
                                .id) {
                          _productList.add(product);
                        }
                      });
                    }
                  }
                }
              }
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 18,
                        ),
                        topStepWidgets(
                          screenWidth,
                          mContext: context,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        if (selStepIndex == 0)
                          Padding(
                            padding: const EdgeInsets.all(mariHorPadding),
                            child: firstStepWidget(context),
                          ),
                        if (selStepIndex == 1)
                          ReserveProducts(
                            onClickNext: () {
                              setState(() {
                                selStepIndex = 2;
                              });
                            },
                          ),
                        if (selStepIndex == 2)
                          ConfirmReserveScreen(
                            restaurant: widget.restaurant,
                            errorMessage: strErrorMessage,
                            onClickNext: () {
                              onConfirmPay();
                            },
                          ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black87.withOpacity(0.3),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Processing...',
                              style: robotoMedium.copyWith(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            );
          });
        }),
      ),
    );
  }

  Widget firstStepWidget(BuildContext __context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'Place Name'.tr}',
            style: robotoMedium.copyWith(
              fontSize: 14,
              color:
                  Theme.of(context).textTheme.bodyText1.color.withOpacity(0.7),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              12,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6,
              ),
              color: Theme.of(__context).disabledColor.withOpacity(0.3),
              child: MyTextField(
                hintText: 'Place Name'.tr,
                controller: _placeNameCtrl,
                focusNode: _placeNameFocus,
                nextFocus: _numberInFocus,
                inputType: TextInputType.name,
                capitalization: TextCapitalization.words,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            '${'Number in party'.tr}',
            style: robotoMedium.copyWith(
              fontSize: 14,
              color: Theme.of(__context)
                  .textTheme
                  .bodyText1
                  .color
                  .withOpacity(0.7),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              12,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6,
              ),
              color: Theme.of(__context).disabledColor.withOpacity(0.3),
              child: MyTextField(
                hintText: 'Number in party'.tr,
                controller: _numberInCtrl,
                focusNode: _numberInFocus,
                nextFocus: _specialFocus,
                inputType: TextInputType.phone,
                capitalization: TextCapitalization.words,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            '${'Special Notes'.tr}',
            style: robotoMedium.copyWith(
              fontSize: 14,
              color: Theme.of(__context)
                  .textTheme
                  .bodyText1
                  .color
                  .withOpacity(0.7),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              12,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6,
              ),
              color: Theme.of(__context).disabledColor.withOpacity(0.3),
              child: MyTextField(
                hintText: 'Special Notes'.tr,
                controller: _specialCtrl,
                focusNode: _specialFocus,
                inputType: TextInputType.emailAddress,
                fillColor: Colors.transparent,
                maxLines: 5,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (_placeNameCtrl.text.isNotEmpty) {
                if (_numberInCtrl.text.isNotEmpty) {
                  if (_specialCtrl.text.isNotEmpty) {
                    Get.find<ReservationController>().setReserveOptions(
                      _numberInCtrl.text,
                      _specialCtrl.text,
                    );
                    Get.find<ReservationController>().setPlaceName(
                      _placeNameCtrl.text,
                    );
                    setState(() {
                      selStepIndex = 1;
                    });
                  } else {
                    showCustomSnackBar(
                      'Please fill special note.'.tr,
                      isError: false,
                    );
                  }
                } else {
                  showCustomSnackBar(
                    'Please fill number in party.'.tr,
                    isError: false,
                  );
                }
              } else {
                showCustomSnackBar(
                  'Please fill place name.'.tr,
                  isError: false,
                );
              }
            },
            child: Container(
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
              child: Center(
                child: Text(
                  'Continue'.tr,
                  style: robotoMedium.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topStepWidgets(
    double screenWidth, {
    BuildContext mContext,
  }) {
    double dotLineWidth = 52;
    return Container(
      width: screenWidth,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 30,
                child: Center(
                  child: Text(
                    '${stepTitles[0]}',
                    style: robotoMedium.copyWith(
                      fontSize: 12,
                      color: selStepIndex == 0
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Container(
                width: 64,
                height: 30,
                child: Center(
                  child: Text(
                    '${stepTitles[1]}',
                    style: robotoMedium.copyWith(
                      fontSize: 12,
                      color: selStepIndex == 1
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Container(
                width: 64,
                height: 30,
                child: Center(
                  child: Text(
                    '${stepTitles[2]}',
                    style: robotoMedium.copyWith(
                      fontSize: 12,
                      color: selStepIndex == 2
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Container(
                width: 64,
                height: 30,
                child: Center(
                  child: Text(
                    '${stepTitles[3]}',
                    style: robotoMedium.copyWith(
                      fontSize: 12,
                      color: selStepIndex == 3
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  border: Border.all(
                    width: 1,
                    color: selStepIndex == 0
                        ? Theme.of(mContext).primaryColor
                        : Theme.of(mContext).disabledColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: robotoMedium.copyWith(
                      fontSize: 16,
                      color: selStepIndex == 0
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: dotLineWidth,
                child: DottedLine(
                  dashColor: Theme.of(mContext).disabledColor,
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  border: Border.all(
                    width: 1,
                    color: selStepIndex == 1
                        ? Theme.of(mContext).primaryColor
                        : Theme.of(mContext).disabledColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: robotoMedium.copyWith(
                      fontSize: 16,
                      color: selStepIndex == 1
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: dotLineWidth,
                child: DottedLine(
                  dashColor: Theme.of(mContext).disabledColor,
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  border: Border.all(
                    width: 1,
                    color: selStepIndex == 2
                        ? Theme.of(mContext).primaryColor
                        : Theme.of(mContext).disabledColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    '3',
                    style: robotoMedium.copyWith(
                      fontSize: 16,
                      color: selStepIndex == 2
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: dotLineWidth,
                child: DottedLine(
                  dashColor: Theme.of(mContext).disabledColor,
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  border: Border.all(
                    width: 1,
                    color: selStepIndex == 2
                        ? Theme.of(mContext).primaryColor
                        : Theme.of(mContext).disabledColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    '4',
                    style: robotoMedium.copyWith(
                      fontSize: 16,
                      color: selStepIndex == 3
                          ? Theme.of(mContext).primaryColor
                          : Theme.of(mContext).disabledColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  var stepTitles = [
    'Fill Place Info',
    'Choose Food',
    'Confirm & Pay',
    'Complete',
  ];

  void onConfirmPay() {
    var _isAvailable = true;
    DateTime curDate = DateTime.now();
    DateTime _scheduleStartDate = DateTime(
        curDate.year, curDate.month, curDate.day, curDate.hour, curDate.minute);

    for (CartModel cart in Get.find<CartController>().cartList) {
      if (!DateConverter.isAvailable(
        cart.product.availableTimeStarts,
        cart.product.availableTimeEnds,
        time: _scheduleStartDate,
      )) {
        _isAvailable = false;
        break;
      }
    }
    if (_isAvailable) {
      uploadOrderData();
    } else {
      showCustomSnackBar(
        'One or more products are no available.'.tr,
      );
    }
  }

  void uploadOrderData() {
    if (Get.find<CartController>().cartList.isNotEmpty) {
      List<CartModel> _cartList = [];
      List<Cart> carts = [];
      _cartList.addAll(Get.find<CartController>().cartList);

      for (int index = 0; index < _cartList.length; index++) {
        CartModel cart = _cartList[index];
        List<int> _addOnIdList = [];
        List<int> _addOnQtyList = [];
        cart.addOnIds.forEach((addOn) {
          _addOnIdList.add(addOn.id);
          _addOnQtyList.add(addOn.quantity);
        });
        carts.add(
          Cart(
            cart.product.id,
            cart.product.id,
            cart.discountedPrice.toString(),
            '',
            cart.variation,
            cart.quantity,
            _addOnIdList,
            cart.addOns,
            _addOnQtyList,
          ),
        );
      }

      DateTime _curDate = DateTime.now();
      _date =
          '${_curDate.year}-${_curDate.month < 10 ? '0${_curDate.month}' : _curDate.month}-${_curDate.day < 10 ? '0${_curDate.day}' : _curDate.day}';
      _startTime =
          '${_curDate.hour < 10 ? '0${_curDate.hour}' : _curDate.hour}:${_curDate.minute < 10 ? '0${_curDate.minute}' : _curDate.minute}';
      Get.find<ReservationController>()
          .setReserveTime(_date, _startTime, _startTime);

      setState(() {
        isLoading = true;
      });
      Get.find<OrderController>().placeReservePlaceOrder(
        PlaceOrderBody(
          cart: carts,
          couponDiscountAmount: Get.find<CouponController>().discount,
          distance: Get.find<OrderController>().distance,
          couponDiscountTitle: Get.find<CouponController>().discount > 0
              ? Get.find<CouponController>().coupon.title
              : null,
          scheduleAt:
              '${Get.find<ReservationController>().reservation.reserveDate} ${Get.find<ReservationController>().reservation.endTime}:00',
          orderAmount: Get.find<ReservationController>().total,
          orderNote:
              '${Get.find<ReservationController>().reservation.specialNotes}',
          orderType: 'reserveplace',
          paymentMethod: Get.find<OrderController>().paymentMethodIndex == 0
              ? 'cash_on_delivery'
              : Get.find<OrderController>().paymentMethodIndex == 1
                  ? 'digital_payment'
                  : Get.find<OrderController>().paymentMethodIndex == 2
                      ? 'wallet'
                      : 'digital_payment',
          couponCode: (Get.find<CouponController>().discount > 0 ||
                  (Get.find<CouponController>().coupon != null &&
                      Get.find<CouponController>().freeDelivery))
              ? Get.find<CouponController>().coupon.code
              : null,
          restaurantId: _cartList[0].product.restaurantId,
          address: widget.restaurant.address,
          latitude: widget.restaurant.latitude,
          longitude: widget.restaurant.longitude,
          addressType: 'ReservePlace',
          contactPersonName:
              '${Get.find<ReservationController>().reservation.customerName}',
          contactPersonNumber:
              '${Get.find<ReservationController>().reservation.customerPhone}',
          discountAmount: 0,
          road: '',
          house: '',
          floor: '',
          dmTips: '0',
          totalTaxAmount: Get.find<ReservationController>().totalTaxAmount,
          serviceCharge: Get.find<ReservationController>().serviceCharge,
          serverTip: Get.find<ReservationController>().serverTip,
          promo: Get.find<ReservationController>().promo,
          serverTipMethod: Get.find<ReservationController>().serverTipMethod,
        ),
        _callback,
        Get.find<ReservationController>().total,
        Get.find<UserController>().userInfoModel.id,
      );
    } else {
      showCustomSnackBar('Please select some foods.'.tr);
    }
  }

  void _callback(
    bool isSuccess,
    String message,
    String orderID,
    double amount,
  ) async {
    if (isSuccess) {
      Get.find<ReservationController>().setOrderData(orderID, amount);
      Get.find<CartController>().clearCartList();
      Get.find<CouponController>().removeCouponData(false);

      Get.find<ReservationController>().setPaymentStatus('unpaid');
      Get.find<ReservationController>().postReservePlace().then((value) {
        Get.offNamed(
          RouteHelper.getPaymentReserveRoute(
            orderID,
            Get.find<UserController>().userInfoModel.id,
            amount,
          ),
        );
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
