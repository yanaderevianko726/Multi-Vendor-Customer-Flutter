import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/distance_model.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/timeslote_model.dart';
import 'package:efood_multivendor/data/repository/order_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;

  OrderController({
    @required this.orderRepo,
  });

  List<OrderModel> _deliveryRunningOrderList = [];
  List<OrderModel> _deliveryHistoryOrderList = [];
  List<OrderModel> _reserveOrderList = [];
  List<OrderDetailsModel> _orderDetails = [];
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  bool _isLoading = false;
  bool _showCancelled = false;
  String _orderType = 'delivery';
  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;
  int _selectedDateSlot = 0;
  int _selectedTimeSlot = 0;
  int _selectedTips = -1;
  double _distance;
  bool _runningPaginate = false;
  bool _runningReservePaginate = false;
  int _runningPageSize;
  int _runningReservePageSize;
  List<int> _deliveryRunningOffsetList = [];
  int _deliveryRunningOrderOffset = 1;
  List<int> _deliveryHistoryOffsetList = [];
  int _deliveryHistoryOffset = 1;
  bool _historyPaginate = false;
  int _historyPageSize;
  double _tips = 0.0;

  List<OrderModel> get deliveryRunningOrderList => _deliveryRunningOrderList;

  List<OrderModel> get deliveryHistoryOrderList => _deliveryHistoryOrderList;

  List<OrderModel> get reserveOrderList => _reserveOrderList;

  List<OrderDetailsModel> get orderDetails => _orderDetails;

  int get paymentMethodIndex => _paymentMethodIndex;

  OrderModel get trackModel => _trackModel;

  ResponseModel get responseModel => _responseModel;

  bool get isLoading => _isLoading;

  bool get showCancelled => _showCancelled;

  String get orderType => _orderType;

  List<TimeSlotModel> get timeSlots => _timeSlots;

  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;

  int get selectedDateSlot => _selectedDateSlot;

  int get selectedTimeSlot => _selectedTimeSlot;

  int get selectedTips => _selectedTips;

  double get distance => _distance;

  bool get runningPaginate => _runningPaginate;

  bool get runningReservePaginate => _runningReservePaginate;

  int get runningPageSize => _runningPageSize;

  int get runningReservePageSize => _runningReservePageSize;

  int get deliveryOrdersOffset => _deliveryRunningOrderOffset;

  int get deliveryHistoryOffset => _deliveryHistoryOffset;

  bool get historyPaginate => _historyPaginate;

  int get historyPageSize => _historyPageSize;

  double get tips => _tips;

  void addTips(double tips) {
    _tips = tips;
    update();
  }

  Future<void> getDeliveryRunningOrders(int offset) async {
    if (offset == 1) {
      _deliveryRunningOrderOffset = 1;
      update();
    }
    if (!_deliveryRunningOffsetList.contains(offset)) {
      _deliveryRunningOffsetList.add(offset);
      Response response = await orderRepo.getDeliveryOrders(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _deliveryRunningOrderList = [];
        }
        _deliveryRunningOrderList.addAll(
          PaginatedOrderModel.fromJson(response.body).orders,
        );
        _runningPageSize =
            PaginatedOrderModel.fromJson(response.body).totalSize;
        _runningPaginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (_runningPaginate) {
        _runningPaginate = false;
        update();
      }
    }
  }

  Future<void> getDeliveryHistoryOrders(int offset) async {
    if (offset == 1) {
      _deliveryHistoryOffsetList = [];
      _deliveryHistoryOrderList = null;
      update();
    }
    _deliveryHistoryOffset = offset;
    if (!_deliveryHistoryOffsetList.contains(offset)) {
      _deliveryHistoryOffsetList.add(offset);
      Response response = await orderRepo.getHistoryOrderList(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _deliveryHistoryOrderList = [];
        }
        _deliveryHistoryOrderList
            .addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _historyPageSize =
            PaginatedOrderModel.fromJson(response.body).totalSize;
        _historyPaginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (_historyPaginate) {
        _historyPaginate = false;
        update();
      }
    }
  }

  Future<void> getReserveOrders(int offset) async {
    Response response = await orderRepo.getReserveOrderList(offset);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _reserveOrderList = [];
      }
      _reserveOrderList.addAll(
        PaginatedOrderModel.fromJson(response.body).orders,
      );
      _runningReservePageSize =
          PaginatedOrderModel.fromJson(response.body).totalSize;
      _runningReservePaginate = false;
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void showBottomLoader(bool isRunning) {
    if (isRunning) {
      _runningPaginate = true;
    } else {
      _historyPaginate = true;
    }
    update();
  }

  void setOffset(int offset, bool isRunning) {
    if (isRunning) {
      _deliveryRunningOrderOffset = offset;
    } else {
      _deliveryHistoryOffset = offset;
    }
  }

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    Response response = await orderRepo.getOrderDetails(orderID);
    _isLoading = false;
    if (response.statusCode == 200) {
      _orderDetails = [];
      response.body.forEach((orderDetail) =>
          _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return _orderDetails;
  }

  void setPaymentMethod(int __index, {bool enUpdate = true}) {
    _paymentMethodIndex = __index;
    if (enUpdate) {
      update();
    }
  }

  Future<ResponseModel> trackOrder(
    String orderID,
    OrderModel orderModel,
    bool fromTracking,
  ) async {
    _trackModel = null;
    _responseModel = null;
    if (!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if (orderModel == null) {
      _isLoading = true;
      Response response = await orderRepo.trackOrder(orderID);
      if (response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(response.body);
        _responseModel = ResponseModel(true, response.body.toString());
      } else {
        _responseModel = ResponseModel(false, response.statusText);
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    } else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  Future<void> placeOrder(
    PlaceOrderBody placeOrderBody,
    Function callback,
    double amount,
    String companyName,
    String villageName,
    String aptNumber,
  ) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.placeOrder(
      placeOrderBody,
      companyName,
      villageName,
      aptNumber,
    );
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID, amount);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1', amount);
    }
    update();
  }

  Future<void> placeReserveOrder(
    PlaceOrderBody placeOrderBody,
    Function callback,
    double amount,
    int userId,
  ) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.placeReserveOrder(
      placeOrderBody,
      '$userId',
    );
    _isLoading = false;
    print('responseError: ${response.body}');
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID, amount);
      print('-------- Order placed successfully $orderID ----------');
    } else if (response.statusCode == 201) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID, amount);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1', amount);
    }

    update();
  }

  Future<void> placeReservePlaceOrder(
    PlaceOrderBody placeOrderBody,
    Function callback,
    double amount,
    int userId,
  ) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.placeReservePlaceOrder(
      placeOrderBody,
      '$userId',
    );
    _isLoading = false;
    print('responseError: ${response.body}');
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID, amount);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1', amount);
    }

    update();
  }

  void stopLoader() {
    _isLoading = false;
    update();
  }

  void clearPrevData() {
    _paymentMethodIndex = Get.find<SplashController>()
            .configModel
            .cashOnDelivery
        ? 0
        : Get.find<SplashController>().configModel.digitalPayment
            ? 1
            : Get.find<SplashController>().configModel.customerWalletStatus == 1
                ? 2
                : 0;
    _selectedDateSlot = 0;
    _selectedTimeSlot = 0;
    _distance = null;
  }

  void cancelOrder(int orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.cancelOrder(orderID.toString());
    _isLoading = false;
    Get.back();
    if (response.statusCode == 200) {
      OrderModel orderModel;
      for (OrderModel order in _deliveryRunningOrderList) {
        if (order.id == orderID) {
          orderModel = order;
          break;
        }
      }
      _deliveryRunningOrderList.remove(orderModel);
      _showCancelled = true;
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      print(response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<ResponseModel> completeOrder(int orderID, int reservationId) async {
    Response response = await orderRepo.completeOrder(
      orderID.toString(),
      reservationId.toString(),
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      OrderModel orderModel;
      for (OrderModel order in _deliveryRunningOrderList) {
        if (order.id == orderID) {
          orderModel = order;
          break;
        }
      }
      _deliveryRunningOrderList.remove(orderModel);
      _deliveryHistoryOrderList.add(orderModel);
      responseModel = ResponseModel(true, 'Success');
    } else {
      responseModel = ResponseModel(false, 'Failed');
      ApiChecker.checkApi(response);
    }
    update();
    return responseModel;
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if (notify) {
      update();
    }
  }

  Future<void> initializeTimeSlot(Restaurant restaurant) async {
    _timeSlots = [];
    _allTimeSlots = [];
    int _minutes = 0;
    DateTime _now = DateTime.now();
    for (int index = 0; index < restaurant.schedules.length; index++) {
      print('=== restaurant.schedules.day: ${restaurant.schedules[index].day}');
      print(
          '=== restaurant.schedules.openTime: ${restaurant.schedules[index].openingTime}');
      print(
          '=== restaurant.schedules.closeTime: ${restaurant.schedules[index].closingTime}');
      DateTime _openTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        DateConverter.convertStringTimeToDate(
                restaurant.schedules[index].openingTime)
            .hour,
        DateConverter.convertStringTimeToDate(
                restaurant.schedules[index].openingTime)
            .minute,
      );
      DateTime _closeTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        DateConverter.convertStringTimeToDate(
                restaurant.schedules[index].closingTime)
            .hour,
        DateConverter.convertStringTimeToDate(
                restaurant.schedules[index].closingTime)
            .minute,
      );
      if (_closeTime.difference(_openTime).isNegative) {
        _minutes = _openTime.difference(_closeTime).inMinutes;
      } else {
        _minutes = _closeTime.difference(_openTime).inMinutes;
      }
      if (_minutes >
          Get.find<SplashController>().configModel.scheduleOrderSlotDuration) {
        DateTime _time = _openTime;
        for (;;) {
          if (_time.isBefore(_closeTime)) {
            DateTime _start = _time;
            DateTime _end = _start.add(Duration(
                minutes: Get.find<SplashController>()
                    .configModel
                    .scheduleOrderSlotDuration));
            if (_end.isAfter(_closeTime)) {
              _end = _closeTime;
            }
            _timeSlots.add(TimeSlotModel(
                day: restaurant.schedules[index].day,
                startTime: _start,
                endTime: _end));
            _allTimeSlots.add(TimeSlotModel(
                day: restaurant.schedules[index].day,
                startTime: _start,
                endTime: _end));
            _time = _time.add(Duration(
                minutes: Get.find<SplashController>()
                    .configModel
                    .scheduleOrderSlotDuration));
          } else {
            break;
          }
        }
      } else {
        _timeSlots.add(TimeSlotModel(
            day: restaurant.schedules[index].day,
            startTime: _openTime,
            endTime: _closeTime));
        _allTimeSlots.add(TimeSlotModel(
            day: restaurant.schedules[index].day,
            startTime: _openTime,
            endTime: _closeTime));
      }
    }
    validateSlot(_allTimeSlots, 0, notify: false);
  }

  void updateTimeSlot(int index) {
    _selectedTimeSlot = index;
    update();
  }

  void updateTips(int index) {
    _selectedTips = index;
    update();
  }

  void updateDateSlot(int index) {
    _selectedDateSlot = index;
    if (_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    update();
  }

  void validateSlot(
    List<TimeSlotModel> slots,
    int dateIndex, {
    bool notify = true,
  }) {
    _timeSlots = [];
    int _day = 0;
    if (dateIndex == 0) {
      _day = DateTime.now().weekday;
    } else {
      _day = DateTime.now().add(Duration(days: 1)).weekday;
    }
    if (_day == 7) {
      _day = 0;
    }
    slots.forEach((slot) {
      if (_day == slot.day &&
          (dateIndex == 0 ? slot.endTime.isAfter(DateTime.now()) : true)) {
        _timeSlots.add(slot);
      }
    });
    if (notify) {
      update();
    }
  }

  Future<bool> switchToCOD(String orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.switchToCOD(orderID);
    bool _isSuccess;
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<double> getDistanceInMeter(
    LatLng originLatLng,
    LatLng destinationLatLng,
  ) async {
    _distance = -1;
    Response response =
        await orderRepo.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _distance = DistanceModel.fromJson(response.body)
                .rows[0]
                .elements[0]
                .distance
                .value /
            1000;
      } else {
        _distance = Geolocator.distanceBetween(
              originLatLng.latitude,
              originLatLng.longitude,
              destinationLatLng.latitude,
              destinationLatLng.longitude,
            ) /
            1000;
      }
    } catch (e) {
      _distance = Geolocator.distanceBetween(
            originLatLng.latitude,
            originLatLng.longitude,
            destinationLatLng.latitude,
            destinationLatLng.longitude,
          ) /
          1000;
    }
    update();
    return _distance;
  }
}
