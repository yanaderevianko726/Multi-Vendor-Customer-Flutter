import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryModel {
  int _id;
  String _name;
  int _parentId;
  int _position;
  int _status;
  String _createdAt;
  String _updatedAt;
  String _image;

  CategoryModel({
    int id,
    String name,
    int parentId,
    int position,
    int status,
    String createdAt,
    String updatedAt,
    String image,
  }) {
    this._id = id;
    this._name = name;
    this._parentId = parentId;
    this._position = position;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._image = image;
  }

  int get id => _id;
  String get name => _name;
  int get parentId => _parentId;
  int get position => _position;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get image => _image;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['image'] = this._image;
    return data;
  }

  static Widget listUIWidget({
    List<CategoryModel> categories,
    int selId = 0,
    double height = 72,
    Function onClickCell,
  }) {
    double cellWidth = height * 0.7;
    double radius = 10;
    var baseImgUrl =
        '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/';
    return Container(
      width: double.infinity,
      height: height,
      child: categories != null
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, _index) {
                var imgUrl = '$baseImgUrl${categories[_index].image}';
                return _index == 0
                    ? InkWell(
                        onTap: () {
                          if (onClickCell != null) {
                            onClickCell(10);
                          }
                        },
                        child: Container(
                          width: cellWidth,
                          margin: EdgeInsets.all(
                            Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: cellWidth,
                                height: cellWidth,
                                child: Card(
                                  elevation: 5,
                                  color: categories[_index].id == selId
                                      ? orangeLight
                                      : Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      radius,
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: cellWidth,
                                    height: cellWidth,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/image/ic_delivery.png',
                                        width: cellWidth * 0.6,
                                        height: cellWidth * 0.6,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    categories[_index].name,
                                    style: robotoMedium.copyWith(
                                      color: categories[_index].id == selId
                                          ? Theme.of(context).primaryColor
                                          : null,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          if (onClickCell != null) {
                            onClickCell(categories[_index].id);
                          }
                        },
                        child: Container(
                          width: cellWidth,
                          margin: EdgeInsets.all(
                            Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: cellWidth,
                                height: cellWidth,
                                child: Card(
                                  elevation: 5,
                                  color: categories[_index].id == selId
                                      ? Color.fromARGB(235, 247, 200, 197)
                                      : Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      radius,
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: cellWidth,
                                    height: cellWidth,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          radius,
                                        ),
                                        child: CustomImage(
                                          image: imgUrl,
                                          width: cellWidth,
                                          height: cellWidth,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    categories[_index].name,
                                    style: robotoMedium.copyWith(
                                      color: categories[_index].id == selId
                                          ? Theme.of(context).primaryColor
                                          : null,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            )
          : SizedBox(),
    );
  }
}
