import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class VenueClassifyModel {
  int id;
  String classifyName;
  String assetUri;

  VenueClassifyModel(int i, String n, String a) {
    id = i;
    classifyName = n;
    assetUri = a;
  }

  static Widget listUIWidget({
    List<VenueClassifyModel> venueClassifyModels,
    int selIndex = 0,
    double height = 72,
    Function onClickCell,
  }) {
    double allMargin = Dimensions.PADDING_SIZE_EXTRA_SMALL;
    double cellWidth = height - allMargin * 2;
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: venueClassifyModels != null
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: venueClassifyModels.length,
              itemBuilder: (context, _index) {
                var imgUri =
                    'assets/image/${venueClassifyModels[_index].assetUri}';
                return InkWell(
                  onTap: () {
                    if (onClickCell != null) {
                      onClickCell(venueClassifyModels[_index].id);
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
                            color: venueClassifyModels[_index].id == selIndex
                                ? Color.fromARGB(235, 247, 200, 197)
                                : Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                cellWidth * 0.5,
                              ),
                            ),
                            child: SizedBox(
                              width: cellWidth,
                              height: cellWidth,
                              child: Center(
                                child: Image.asset(
                                  imgUri,
                                  width: _index == 0
                                      ? cellWidth * 0.4
                                      : cellWidth * 0.5,
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
                              venueClassifyModels[_index].classifyName,
                              style: robotoMedium.copyWith(
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
