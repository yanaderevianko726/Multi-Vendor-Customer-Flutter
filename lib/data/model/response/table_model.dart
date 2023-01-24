import 'dart:convert';

import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:get/get.dart';

import 'cart_model.dart';

class TableModel {
  int id;
  String tableName;
  String image;
  int restaurantId;
  int reserveStatus;
  int capacity;
  int floorNumber;
  int status;
  String createdAt;
  String updatedAt;
  List<TableSchedule> schedules;

  TableModel({
    this.id,
    this.tableName,
    this.image,
    this.restaurantId,
    this.reserveStatus,
    this.schedules,
    this.capacity,
    this.floorNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    List<String> scheduleMap = [];
    schedules.forEach(
        (scheduleModel) => scheduleMap.add(jsonEncode(scheduleModel.toMap())));
    var paramSchedule = jsonEncode(scheduleMap);
    return {
      'id': this.id,
      'table_name': this.tableName,
      'image': this.image,
      'venue_id': this.restaurantId,
      'reserved_status': this.reserveStatus,
      'schedules': '${paramSchedule.toString()}',
      'capacity': this.capacity,
      'floor_number': this.floorNumber,
      'status': this.status,
      'created_at': this.createdAt,
      'updated_at': this.updatedAt,
    };
  }

  factory TableModel.fromJson(Map<String, dynamic> map) {
    List<TableSchedule> _schedules = [];
    if (map['schedules'] != null && map['schedules'] != '') {
      List<dynamic> scheduleMap = jsonDecode(map['schedules']);
      print('=== scheduleMap: $scheduleMap');
      scheduleMap.forEach((element) {
        Map<String, dynamic> scheduleMap = jsonDecode(element);
        print('=== scheduleMap: $scheduleMap');
        TableSchedule schedule = TableSchedule.fromMap(scheduleMap);
        _schedules.add(schedule);
      });
    }

    return TableModel(
      id: map['id'] as int,
      tableName: map['table_name'] as String,
      image: map['image'] as String,
      restaurantId: map['venue_id'] as int,
      reserveStatus: map['reserved_status'] as int,
      capacity: map['capacity'] as int,
      floorNumber: map['floor_number'] as int,
      status: map['status'] as int,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      schedules: _schedules,
    );
  }

  String jsonEncodeSchedule() {
    String result = '';
    if (schedules.isNotEmpty) {
      result = '\"[';
      int cnt = 0;
      schedules.forEach((element) {
        result += '${element.toMap()}';
        if (cnt < schedules.length - 1) {
          result += ',';
        }
        cnt++;
      });
      result += ']\"';
    }
    return result;
  }

  TableModel copyWith({
    int id,
    String tableName,
    String image,
    int restaurantId,
    int reserveStatus,
    String schedules,
    int capacity,
    int floorNumber,
    int status,
    String createdAt,
    String updatedAt,
  }) {
    return TableModel(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      image: image ?? this.image,
      restaurantId: restaurantId ?? this.restaurantId,
      reserveStatus: reserveStatus ?? this.reserveStatus,
      schedules: schedules ?? this.schedules,
      capacity: capacity ?? this.capacity,
      floorNumber: floorNumber ?? this.floorNumber,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool checkSchedules(String __date, String strStartTime, String strEndTime) {
    print('=== reserveTime: $__date');
    var splitDate = __date.split('-');
    int rD = int.parse(splitDate[2]);
    int rM = int.parse(splitDate[1]);
    int rY = int.parse(splitDate[0]);

    var hm = strStartTime.split(':');
    int sH = int.parse(hm[0]);
    int sM = int.parse(hm[1]);

    var available = true;

    if (schedules != null && schedules.isNotEmpty) {
      schedules.forEach((element) {
        var _splitDate = element.reserveDate.split('-');
        int rrD = int.parse(_splitDate[2]);
        int rrM = int.parse(_splitDate[1]);
        int rrY = int.parse(_splitDate[0]);

        var __cch = true;
        if(rY < rrY || rM < rrM || rD < rrD){
          available = false;
          __cch = false;
        }else{
          if(__cch){
            if(rY == rrY){
              if(rM == rrM){
                if(rD == rrD){
                  var hm1 = element.endTime.split(':');
                  int schEH = int.parse(hm1[0]);
                  int schEM = int.parse(hm1[1]);

                  if (sH < schEH) {
                    available = false;
                  } else if (sH == schEH) {
                    if (sM <= schEM) {
                      available = false;
                    }
                  }
                }
              }
            }
          }
        }
      });
    }
    return available;
  }

  bool checkProductAvailableTimes(
    String strDate,
    String strStartTime,
    String strEndTime,
  ) {
    bool _isAvailable = true;
    var hm = strStartTime.split(':');
    int sH = int.parse(hm[0]);
    int sM = int.parse(hm[1]);

    var hm1 = strEndTime.split(':');
    int eH = int.parse(hm1[0]);
    int eM = int.parse(hm1[1]);

    var d1 = strDate.split('-');
    int rDay = int.parse(d1[2]);
    int rMonth = int.parse(d1[1]);
    int rYear = int.parse(d1[0]);

    DateTime _scheduleStartDate = DateTime(rYear, rMonth, rDay, sH, sM + 1);
    DateTime _scheduleEndDate = DateTime(rYear, rMonth, rDay, eH, eM + 1);

    for (CartModel cart in Get.find<CartController>().cartList) {
      if (!DateConverter.isAvailable(
            cart.product.availableTimeStarts,
            cart.product.availableTimeEnds,
            time: _scheduleStartDate,
          ) &&
          !DateConverter.isAvailable(
            cart.product.availableTimeStarts,
            cart.product.availableTimeEnds,
            time: _scheduleEndDate,
          )) {
        _isAvailable = false;
        break;
      }
    }

    return _isAvailable;
  }
}

class TableSchedule {
  String reserveDate;
  String startTime;
  String endTime;

  TableSchedule({
    this.reserveDate,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': this.reserveDate,
      'start_time': this.startTime,
      'end_time': this.endTime,
    };
  }

  factory TableSchedule.fromMap(Map<String, dynamic> map) {
    return TableSchedule(
      reserveDate: map['date'] as String,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
    );
  }

  DateTime getDateTime() {
    var hm = startTime.split(':');
    int sH = int.parse(hm[0]);
    int sM = int.parse(hm[1]);

    var d1 = reserveDate.split('-');
    int day = int.parse(d1[2]);
    int month = int.parse(d1[1]);
    int year = int.parse(d1[0]);
    return DateTime(year, month, day, sH, sM);
  }
}
