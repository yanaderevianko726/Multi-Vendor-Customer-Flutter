import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedTag extends StatelessWidget {
  final double fromTop;
  final double fontSize;
  final int style;

  FeaturedTag({
    this.fromTop = 10,
    this.fontSize = 10,
    this.style = 0, // 0: featured, 1: trending, 2: isNew
  });

  @override
  Widget build(BuildContext context) {
    return style == 0
        ? Container(
            width: 92,
            height: 36,
            margin: EdgeInsets.only(top: 10, left: 6),
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Center(
              child: Text(
                '${'featured'.tr}  ',
                style: robotoMedium.copyWith(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : style == 1
            ? Container(
                width: 90,
                margin: EdgeInsets.only(left: 1.4, top: 10),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/image/ic_featured_label.png',
                      width: 92,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, left: 8),
                      child: Text(
                        '${'featured'.tr}  ',
                        style: robotoMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: 90,
                margin: EdgeInsets.only(left: 1.4, top: 10),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/image/ic_featured_label.png',
                      width: 92,
                      height: 40,
                      fit: BoxFit.fill,
                      color: yellowDark,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, left: 8),
                      child: Text(
                        '${'Premium'.tr}  ',
                        style: robotoMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
  }
}
