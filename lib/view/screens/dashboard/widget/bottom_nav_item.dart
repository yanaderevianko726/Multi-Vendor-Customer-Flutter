import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final String assetData;
  final String title;
  final Function onTap;
  final bool isSelected;
  final double iconSize;
  final double fontSize;
  BottomNavItem({
    @required this.assetData,
    this.onTap,
    this.isSelected = false,
    this.iconSize,
    this.title,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 24,
            child: Center(
              child: Image.asset(
                assetData,
                height: iconSize,
                fit: BoxFit.fitHeight,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context)
                        .textTheme
                        .bodyText1
                        .color
                        .withOpacity(0.6),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          SizedBox(
            height: 24,
            child: Center(
              child: Text(
                '$title',
                style: robotoMedium.copyWith(
                  fontSize: fontSize,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
