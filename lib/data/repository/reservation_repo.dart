import 'dart:convert';

import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/response/reservation_model.dart';
import 'package:efood_multivendor/data/model/response/table_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ReservationRepo {
  final ApiClient apiClient;
  ReservationRepo({
    @required this.apiClient,
  });

  Future<Response> getReservationList(
    String customerId,
  ) async {
    return await apiClient.getData(
      '${AppConstants.RESERVATIONS_URI}?customer_id=$customerId',
    );
  }

  Future<Response> getReservationInfo(
    String reservationId,
  ) async {
    return await apiClient.getData(
      '${AppConstants.RESERVATION_INFO_URI}?reservation_id=$reservationId',
    );
  }

  Future<Response> postReservation(
    ReservationModel reservation,
  ) async {
    return await apiClient.postData(
      AppConstants.POST_RESERVATION_URI,
      reservation.toJson(),
    );
  }

  Future<Response> postReservePlace(
    ReservationModel reservation,
  ) async {
    return await apiClient.postData(
      AppConstants.POST_RESERVE_PLACE_URI,
      reservation.toJson(),
    );
  }

  Future<Response> updateReservationWithPay(
    ReservationModel reservation,
  ) async {
    return await apiClient.getData(
      '${AppConstants.UPDATE_RESERVATION_WITH_PAY_URI}?customer_id=${reservation.customerId}&payment_status=${reservation.paymentStatus}&order_id=${reservation.orderId}',
    );
  }

  Future<Response> getTableList(
    String restaurantId,
  ) async {
    return await apiClient.getData(
      '${AppConstants.TABLES_URI}?restaurant_id=$restaurantId',
    );
  }

  Future<Response> updateTable(
    TableModel tableModel,
  ) async {
    List<String> scheduleMap = [];
    tableModel.schedules.forEach(
      (scheduleModel) => scheduleMap.add(
        jsonEncode(
          scheduleModel.toMap(),
        ),
      ),
    );
    var paramSchedule = jsonEncode(scheduleMap);
    return await apiClient.postData(AppConstants.UPDATE_TABLES_URI, {
      'id': tableModel.id,
      'table_name': tableModel.tableName,
      'image': tableModel.image,
      'venue_id': tableModel.restaurantId,
      'reserved_status': tableModel.reserveStatus,
      'schedules': '$paramSchedule',
      'capacity': tableModel.capacity,
      'floor_number': tableModel.floorNumber,
      'status': tableModel.status,
      'created_at': tableModel.createdAt,
      'updated_at': tableModel.updatedAt,
    });
  }
}
