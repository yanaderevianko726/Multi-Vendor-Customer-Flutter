import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/reservation_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/table_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/data/repository/reservation_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';

class ReservationController extends GetxController implements GetxService {
  final ReservationRepo reservationRepo;
  ReservationController({
    @required this.reservationRepo,
  });

  ReservationModel _reservation;
  ReservationModel _trackReservation;
  List<ReservationModel> _allReserveList = [];
  List<ReservationModel> _runningReserveList = [];
  List<ReservationModel> _historyReserveList = [];
  List<ReservationModel> _placeReserveRunningList = [];
  List<ReservationModel> _placeReserveHistoryList = [];
  List<TableModel> _allTables = [];
  bool _isLoading = false;
  int _offset = 1;
  int _selVenueIndex;
  int _selTableIndex;
  double _subTotal;
  double _totalTaxAmount;
  double _total;
  double _tax;
  double _serviceCharge;
  double _serverTip;
  double _promo;
  double _taxAmount;
  double _serviceChargeAmount;
  double _serverTipAmount;
  double _promoAmount;
  int _serverTipMethod = 0;

  ReservationModel get reservation => _reservation;
  ReservationModel get trackReservation => _trackReservation;
  List<ReservationModel> get allReserveList => _allReserveList;
  List<ReservationModel> get runningReserveList => _runningReserveList;
  List<ReservationModel> get historyReserveList => _historyReserveList;
  List<ReservationModel> get placeReserveRunningList =>
      _placeReserveRunningList;
  List<ReservationModel> get placeReserveHistoryList =>
      _placeReserveHistoryList;
  List<TableModel> get allTables => _allTables;
  bool get isLoading => _isLoading;
  int get offset => _offset;
  int get selVenueIndex => _selVenueIndex;
  int get selTableIndex => _selTableIndex;
  double get subTotal => _subTotal;
  double get totalTaxAmount => _totalTaxAmount;
  double get total => _total;
  double get tax => _tax;
  double get serviceCharge => _serviceCharge;
  double get serverTip => _serverTip;
  double get promo => _promo;
  double get taxAmount => _taxAmount;
  double get serviceChargeAmount => _serviceChargeAmount;
  double get serverTipAmount => _serverTipAmount;
  double get promoAmount => _promoAmount;
  int get serverTipMethod => _serverTipMethod;

  Future<void> initReservation(String _date, String _startTime) async {
    _reservation = ReservationModel();
    _reservation.reserveType = 0;
    _reservation.reserveDate = _date;
    _reservation.startTime = _startTime;

    _allTables = [];
    _selVenueIndex = -1;
    _selTableIndex = -1;

    var deviceId = await PlatformDeviceId.getDeviceId;
    _reservation.deviceId = deviceId;

    _reservation.customerId = Get.find<UserController>().userInfoModel.id;
    _reservation.customerName =
        '${Get.find<UserController>().userInfoModel.fName} ${Get.find<UserController>().userInfoModel.lName}';
    _reservation.customerEmail = Get.find<UserController>().userInfoModel.email;
    _reservation.customerPhone = Get.find<UserController>().userInfoModel.phone;

    _subTotal = 0;
    _totalTaxAmount = 0;
    _total = 0;
    _serverTipMethod = 0;

    _tax = 0;
    _serverTip = 0;
    _serviceCharge = 0;
    _promo = 0;

    _totalTaxAmount = 0;
    _serviceChargeAmount = 0;
    _serverTipAmount = 0;
    _promoAmount = 0;

    update();
  }

  Future<void> initReserveForPlace(
    String _date,
    String _startTime,
    Restaurant __restaurant,
  ) async {
    _reservation = ReservationModel();
    _reservation.reserveType = 1;
    _reservation.reserveDate = _date;
    _reservation.startTime = _startTime;
    _reservation.endTime = _startTime;

    _allTables = [];
    _selVenueIndex = -1;
    _selTableIndex = -1;

    _reservation.tableId = 0;
    _reservation.tableName = '';
    _reservation.tableImage = '';

    var deviceId = await PlatformDeviceId.getDeviceId;
    _reservation.deviceId = deviceId;

    _reservation.customerId = Get.find<UserController>().userInfoModel.id;
    _reservation.customerName =
        '${Get.find<UserController>().userInfoModel.fName} ${Get.find<UserController>().userInfoModel.lName}';
    _reservation.customerEmail = Get.find<UserController>().userInfoModel.email;
    _reservation.customerPhone = Get.find<UserController>().userInfoModel.phone;

    _reservation.venueId = __restaurant.id;
    _reservation.venueName = __restaurant.name;
    _reservation.venueAddress = __restaurant.address;
    _reservation.chefId = __restaurant.vendorId;

    _subTotal = 0;
    _totalTaxAmount = 0;
    _total = 0;
    _serverTipMethod = 0;

    _tax = __restaurant.tax ?? 0;
    _serverTip = __restaurant.serverTip ?? 0;
    _serviceCharge = __restaurant.serviceCharge ?? 0;
    _promo = __restaurant.promo ?? 0;

    _totalTaxAmount = 0;
    _serverTipAmount = 0;
    _serviceChargeAmount = 0;
    _promoAmount = 0;

    _reservation.duration = '10';
  }

  void setVenueIndex(int __index) {
    _selVenueIndex = __index;
  }

  void setVenueInfo(Restaurant _restaurant) {
    print('=== setVenueInfo: Refreshed');
    _total = 0;
    _subTotal = 0;
    _totalTaxAmount = 0;
    _serverTipMethod = 0;

    _taxAmount = 0;
    _serviceChargeAmount = 0;
    _serverTipAmount = 0;
    _promoAmount = 0;

    _tax = _restaurant.tax ?? 0;
    _serviceCharge = _restaurant.serviceCharge ?? 0;
    _serverTip = _restaurant.serverTip ?? 0;
    _promo = _restaurant.promo ?? 0;

    _reservation.venueId = _restaurant.id ?? 0;
    _reservation.venueAddress = _restaurant.address ?? '';
    _reservation.venueName = _restaurant.name ?? '';
  }

  void setVendorInfo(Vendor __vendor) {
    if (__vendor != null) {
      _reservation.chefId = __vendor.id;
      _reservation.chefName = '${__vendor.fName} ${__vendor.lName}';
      _reservation.chefPhone = __vendor.phone;
    }
  }

  void setTableInfo(int __index) {
    _selTableIndex = __index;
    _reservation.tableId = _allTables[_selTableIndex].id;
    _reservation.tableName = _allTables[_selTableIndex].tableName;
    _reservation.tableImage = _allTables[_selTableIndex].image;
    update();
  }

  void setPlaceName(String __name) {
    _reservation.tableName = __name;
  }

  void setPaymentStatus(String __paymentStatus) {
    _reservation.paymentStatus = __paymentStatus;
    update();
  }

  void setTrackReservationPaymentStatus(String __paymentStatus) {
    _trackReservation.paymentStatus = __paymentStatus;
    update();
  }

  void setReserveDate(String __date) {
    _reservation.reserveDate = __date;
  }

  void setStartTime(String _startTime) {
    _reservation.startTime = _startTime;
  }

  void setEndTime(String __endTime) {
    _reservation.endTime = __endTime;
  }

  void setOrderData(String orderId, double amount) {
    _reservation.orderId = int.parse(orderId);
    _reservation.orderName = '#$orderId';
    _reservation.price = amount;
  }

  void setReserveTime(String __date, String __startTime, String __endTime) {
    _reservation.reserveDate = __date;
    _reservation.startTime = __startTime;
    _reservation.endTime = __endTime;

    var hm = __startTime.split(':');
    int sH = int.parse(hm[0]);
    int sM = int.parse(hm[1]);

    var hm1 = __endTime.split(':');
    int eH = int.parse(hm1[0]);
    int eM = int.parse(hm1[1]);

    var d1 = __date.split('-');
    int rDay = int.parse(d1[2]);
    int rMonth = int.parse(d1[1]);
    int rYear = int.parse(d1[0]);

    DateTime _reserveStartDate = DateTime(rYear, rMonth, rDay, sH, sM + 1);
    DateTime _reserveEndDate = DateTime(rYear, rMonth, rDay, eH, eM + 1);

    final difference = _reserveEndDate.difference(_reserveStartDate).inMinutes;
    if (difference < 60) {
      _reservation.duration = '$difference min';
    } else {
      int hh = (difference / 60).round();
      if (hh < 24) {
        var mm = difference % 60;
        _reservation.duration = '$hh h $mm min';
      } else {
        int dd = _reserveEndDate.difference(_reserveStartDate).inDays;
        _reservation.duration = '$dd ${dd > 1 ? 'days' : 'day'}';
      }
    }
  }

  void setReserveOptions(String __numInParty, String __notes) {
    _reservation.numberInParty = __numInParty;
    _reservation.specialNotes = __notes;
  }

  void clearTables() {
    _allTables = [];
    _reservation.tableId = -1;
    _reservation.tableName = '';
    _reservation.tableImage = '';
    _selTableIndex = -1;
    update();
  }

  void setServerTipMethod(int __val) {
    _serverTipMethod = __val;
    updateServiceCharges();
  }

  void updateServiceCharges() {
    _totalTaxAmount = 0;
    _total = 0;

    print('=== _tax: $_tax');
    print('=== _serviceCharge: $_serviceCharge');
    print('=== _promo: $_promo');
    print('=== _serverTip: $_serverTip');
    if (_tax > 0) {
      _taxAmount = (_subTotal * _tax) / 100;
    }
    if (_serviceCharge > 0) {
      _serviceChargeAmount = (_subTotal * _serviceCharge) / 100;
    }
    if (_promo > 0) {
      _promoAmount = (_subTotal * _promo) / 100;
    }

    _serverTipAmount = 0;
    if (_serverTip > 0) {
      if (_serverTipMethod == 1) {
        _serverTipAmount = (_subTotal * _serverTip) / 100;
      } else if (_serverTipMethod == 2) {
        _serverTipAmount = _serverTip;
      }
    }

    _totalTaxAmount =
        _taxAmount + _serviceChargeAmount + _serverTipAmount + _promoAmount;
    _total = _subTotal + _totalTaxAmount;
  }

  void setServiceCharges(double __subTotal) {
    _subTotal = __subTotal;
    updateServiceCharges();
  }

  void updateReserveWithPayment(Function __callback) {
    _allReserveList.add(_reservation);
    update();
    __callback();
  }

  void setTrackReservation(ReservationModel __reservation) {
    _trackReservation = __reservation.copyWith();
  }

  Future<ResponseModel> getReservationList(bool reload) async {
    Response response = await reservationRepo.getReservationList(
      '${Get.find<UserController>().userInfoModel.id}',
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (response.body != null) {
        Map<String, dynamic> json = response.body;
        if (json['reservations'] != null) {
          _allReserveList = [];
          _runningReserveList = [];
          _historyReserveList = [];
          _placeReserveRunningList = [];
          _placeReserveHistoryList = [];

          json['reservations'].forEach((v) {
            ReservationModel reservationTmp = ReservationModel.fromJson(v);
            _allReserveList.add(reservationTmp);
            if (reservationTmp.reserveType == 0) {
              if (reservationTmp.reserveStatus < 3) {
                _runningReserveList.add(reservationTmp);
              } else if (reservationTmp.reserveStatus >= 3) {
                _historyReserveList.add(reservationTmp);
              }
            } else if (reservationTmp.reserveType == 1) {
              if (reservationTmp.reserveStatus < 3) {
                _placeReserveRunningList.add(reservationTmp);
              } else if (reservationTmp.reserveStatus >= 3) {
                _placeReserveHistoryList.add(reservationTmp);
              }
            }
          });
          responseModel = ResponseModel(true, 'success');
        }
      } else {
        responseModel = ResponseModel(false, 'failure');
      }
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, 'failure');
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> getReservationInfo(String reservationId) async {
    Response response = await reservationRepo.getReservationInfo(
      '$reservationId',
    );
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (response.body['reservation'] != null) {
        Map<String, dynamic> json = response.body['reservation'];
        print('=== json: $json');
        _trackReservation = ReservationModel.fromJson(json);
        responseModel = ResponseModel(true, 'success');
      } else {
        responseModel = ResponseModel(false, 'failure');
      }
    } else {
      ApiChecker.checkApi(response);
      responseModel = ResponseModel(false, 'failure');
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> postReservation() async {
    Response response = await reservationRepo.postReservation(_reservation);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _reservation.id = response.body['reservation_id'];
      _allReserveList.add(_reservation);
      responseModel = ResponseModel(
        true,
        '${response.body["message"]}',
      );
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> postReservePlace() async {
    Response response = await reservationRepo.postReservePlace(_reservation);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _reservation.id = response.body['reservation_id'];
      _allReserveList.add(_reservation);
      responseModel = ResponseModel(
        true,
        '${response.body["message"]}',
      );
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> updateReservationWithPay() async {
    Response response =
        await reservationRepo.updateReservationWithPay(_reservation);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      int _index = _allReserveList
          .indexWhere((element) => element.id == _reservation.id);
      if (_index != -1) {
        _allReserveList[_index].paymentStatus = _reservation.paymentStatus;
      }
      responseModel = ResponseModel(true, '${response.body["message"]}');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> updateTrackReservationWithPay() async {
    Response response =
        await reservationRepo.updateReservationWithPay(_trackReservation);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      int _index = _allReserveList
          .indexWhere((element) => element.id == _trackReservation.id);
      if (_index != -1) {
        _allReserveList[_index].paymentStatus = _trackReservation.paymentStatus;
      }
      responseModel = ResponseModel(true, '${response.body["message"]}');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<bool> getTableList(String restaurantId) async {
    bool finishLoading = false;
    Response response = await reservationRepo.getTableList(restaurantId);
    if (response.statusCode == 200) {
      if (response.body != null) {
        Map<String, dynamic> json = response.body;
        if (json['tables'] != null) {
          print('=== tablesData: ${json['tables']}');
          _allTables = [];
          json['tables'].forEach((v) {
            TableModel table = TableModel.fromJson(v);
            _allTables.add(table);
          });
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return finishLoading;
  }

  Future<ResponseModel> updateTable(TableModel tableModel) async {
    Response response = await reservationRepo.updateTable(tableModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, '${response.body["message"]}');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }
}
