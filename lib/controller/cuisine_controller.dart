import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/cuisine_model.dart';
import 'package:efood_multivendor/data/repository/cuisine_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CuisineController extends GetxController implements GetxService {
  final CuisineRepo cuisineRepo;
  CuisineController({
    @required this.cuisineRepo,
  });

  List<CuisineModel> _allCuisines = [];
  List<CuisineModel> _cuisinesList = [];
  bool _isLoading = false;
  int _pageSize;
  int _restPageSize;
  bool _isRestaurant = false;
  int _offset = 1;
  String _type = 'all';

  List<CuisineModel> get cuisinesList => _cuisinesList;
  List<CuisineModel> get allCuisinesList => _allCuisines;
  bool get isLoading => _isLoading;
  int get pageSize => _pageSize;
  int get restPageSize => _restPageSize;
  bool get isRestaurant => _isRestaurant;
  int get offset => _offset;
  String get type => _type;

  void addCuisine(int __cuisineId) {
    if (_allCuisines.isNotEmpty) {
      int index =
          _allCuisines.indexWhere((element) => element.id == __cuisineId);
      if (index != -1) {
        if (_cuisinesList.isNotEmpty) {
          int __ind =
              _cuisinesList.indexWhere((element) => element.id == __cuisineId);
          if (__ind == -1) {
            _cuisinesList.add(_allCuisines[index]);
          }
        } else {
          _cuisinesList.add(_allCuisines[index]);
        }
        update();
      }
    }
  }

  void clearCuisines() {
    _cuisinesList = [];
  }

  Future<bool> getCuisinesList(bool reload) async {
    Response response = await cuisineRepo.getCuisinesList();
    if (response.statusCode == 200) {
      print('cuisine response: ${response.body}');
      _allCuisines = [];
      response.body.forEach((category) {
        _allCuisines.add(
          CuisineModel.fromJson(category),
        );
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return true;
  }
}
