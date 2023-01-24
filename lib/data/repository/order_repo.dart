import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  OrderRepo({
    @required this.apiClient,
    @required this.sharedPreferences,
  });

  Future<Response> getDeliveryOrders(int offset) async {
    return await apiClient.getData(
      '${AppConstants.DELIVERY_ORDER_LIST_URI}?offset=$offset&limit=25',
    );
  }

  Future<Response> getHistoryOrderList(int offset) async {
    return await apiClient.getData(
      '${AppConstants.HISTORY_ORDER_LIST_URI}?offset=$offset&limit=25',
    );
  }

  Future<Response> getReserveOrderList(int offset) async {
    return await apiClient.getData(
      '${AppConstants.RESERVE_ORDER_LIST_URI}?offset=$offset&limit=25',
    );
  }

  Future<Response> getOrderDetails(String orderID) async {
    return await apiClient.getData('${AppConstants.ORDER_DETAILS_URI}$orderID');
  }

  Future<Response> cancelOrder(String orderID) async {
    return await apiClient.postData(AppConstants.ORDER_CANCEL_URI, {
      '_method': 'put',
      'order_id': orderID,
    });
  }

  Future<Response> completeOrder(String orderID, String reservationId) async {
    return await apiClient.postData(AppConstants.COMPLETE_ORDER_URI, {
      '_method': 'put',
      'reservation_id': '$reservationId',
      'order_id': orderID,
      'user_id': '${Get.find<UserController>().userInfoModel.id}',
    });
  }

  Future<Response> trackOrder(String orderID) async {
    return await apiClient.getData(
      '${AppConstants.TRACK_URI}$orderID',
    );
  }

  Future<Response> placeOrder(
    PlaceOrderBody orderBody,
    String companyName,
    String villageName,
    String aptNumber,
  ) async {
    return await apiClient.postData(
      AppConstants.PLACE_ORDER_URI,
      orderBody.toJson(companyName, villageName, aptNumber),
    );
  }

  Future<Response> placeReserveOrder(
    PlaceOrderBody orderBody,
    String userId,
  ) async {
    return await apiClient.postData(
      AppConstants.PLACE_RESERVE_ORDER_URI,
      orderBody.toReserveJson(userId),
    );
  }

  Future<Response> placeReservePlaceOrder(
    PlaceOrderBody orderBody,
    String userId,
  ) async {
    return await apiClient.postData(
      AppConstants.PLACE_RESERVE_PLACE_ORDER_URI,
      orderBody.toReserveJson(userId),
    );
  }

  Future<Response> getDeliveryManData(String orderID) async {
    return await apiClient.getData(
      '${AppConstants.LAST_LOCATION_URI}$orderID',
    );
  }

  Future<Response> switchToCOD(String orderID) async {
    return await apiClient.postData(
      AppConstants.COD_SWITCH_URL,
      {'_method': 'put', 'order_id': orderID},
    );
  }

  Future<Response> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng) async {
    return await apiClient.getData(
      '${AppConstants.DISTANCE_MATRIX_URI}'
      '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
      '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}',
    );
  }
}
