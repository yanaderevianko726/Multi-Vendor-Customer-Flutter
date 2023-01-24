import 'package:flutter/material.dart';

class MainFloatingWidget extends StatelessWidget {
  final Color color;
  final bool isSelected;
  MainFloatingWidget({
    @required this.color,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    double iSize = 26;
    return Stack(clipBehavior: Clip.none, children: [
      Image.asset(
        '${isSelected ? 'assets/image/ic_home.png' : 'assets/image/ic_home_red.png'}',
        width: iSize,
        fit: BoxFit.fitWidth,
      ),
      Positioned(
        top: -5,
        right: -5,
        child: Container(
          height: iSize / 2,
          width: iSize / 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
          ),
        ),
      ),
    ]);
  }
}
