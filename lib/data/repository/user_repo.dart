import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({
    @required this.apiClient,
  });

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.CUSTOMER_INFO_URI);
  }

  Future<Response> getGuestInfo() async {
    return await apiClient.getData(AppConstants.GUEST_INFO_URI);
  }

  Future<Response> updateProfile(
      UserInfoModel userInfoModel, XFile data, String token) async {
    Map<String, String> _body = Map();
    _body.addAll(<String, String>{
      'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName,
      'email': userInfoModel.email,
      'phone': userInfoModel.phone,
    });
    return await apiClient.postMultipartData(
        AppConstants.UPDATE_PROFILE_URI, _body, [MultipartBody('image', data)]);
  }

  Future<Response> registerGuestInfo(
    UserInfoModel guestModel,
  ) async {
    Map<String, String> _body = Map();
    _body.addAll(<String, String>{
      'f_name': guestModel.fName,
      'l_name': guestModel.lName,
      'email': guestModel.email,
      'phone': guestModel.phone,
      'device_id': guestModel.deviceId,
    });
    return await apiClient.postData(
      AppConstants.GUEST_REGISTER_URI,
      _body,
    );
  }

  Future<Response> checkGuestEmailAndPhone(String email, String phone) async {
    return await apiClient.getData(
      '${AppConstants.CHECK_GUEST_EMAIL_PHONE_URI}?email=$email&phone=$phone',
    );
  }

  Future<Response> changePassword(UserInfoModel userInfoModel) async {
    return await apiClient.postData(AppConstants.UPDATE_PROFILE_URI, {
      'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName,
      'email': userInfoModel.email,
      'password': userInfoModel.password
    });
  }

  Future<Response> deleteUser() async {
    return await apiClient.deleteData(AppConstants.CUSTOMER_REMOVE);
  }
}
