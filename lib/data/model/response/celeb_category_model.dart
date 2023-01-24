import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class CelebCategoryModel {
  int id;
  String name;
  String imgAsset;

  CelebCategoryModel({
    this.id,
    this.name,
    this.imgAsset,
  });

  static Widget cellUI({
    List<CelebCategoryModel> celebCategories,
    int selId = 0,
    double height = 72,
    Function onClickCell,
  }) {
    double cellWidth = height * 0.7;
    double radius = 10;
    return Container(
      width: double.infinity,
      height: height,
      child: celebCategories != null
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: celebCategories.length,
              itemBuilder: (context, _index) {
                var imgUrl = '${celebCategories[_index].imgAsset}';
                return InkWell(
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
                            color: celebCategories[_index].id == selId
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
                                  '$imgUrl',
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
                              celebCategories[_index].name,
                              style: robotoMedium.copyWith(
                                color: celebCategories[_index].id == selId
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
