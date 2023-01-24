import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/repository/cart_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({@required this.cartRepo});

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
  }

  void addToCart(CartModel cartModel, int index) {
    _cartList.add(cartModel);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void updateToCart(CartModel cartModel, int index) {
    if (index != null && index != -1) {
      _cartList.replaceRange(index, index + 1, [cartModel]);
    }
    update();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
    }
    cartRepo.addToCartList(_cartList);

    update();
  }

  void removeFromCart(int index) {
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartList({bool enUpdate = true}) {
    _cartList = [];
    cartRepo.addToCartList(_cartList);
    if (enUpdate) {
      update();
    }
  }

  int isExistInCart(
      int productID, String variationType, bool isUpdate, int cartIndex) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == productID &&
          (_cartList[index].variation.length > 0
              ? _cartList[index].variation[0].type == variationType
              : true)) {
        if ((isUpdate && index == cartIndex)) {
          return -1;
        } else {
          return index;
        }
      }
    }
    return -1;
  }

  int getCartIndex(Product product) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == product.id) {
        if (_cartList[index].product.variations[0].type != null) {
          if (_cartList[index].product.variations[0].type ==
              product.variations[0].type) {
            return index;
          }
        } else {
          return index;
        }
      }
    }
    return null;
  }

  bool existAnotherRestaurantProduct(int restaurantID) {
    for (CartModel cartModel in _cartList) {
      if (cartModel.product.restaurantId != restaurantID) {
        return true;
      }
    }
    return false;
  }

  void removeAllAndAddToCart(CartModel cartModel) {
    _cartList = [];
    _cartList.add(cartModel);
    cartRepo.addToCartList(_cartList);
    update();
  }
}
