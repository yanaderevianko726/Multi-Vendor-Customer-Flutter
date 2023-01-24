import 'package:efood_multivendor/theme/colors.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function onTap;
  QuantityButton({
    @required this.isIncrement,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 26,
        width: 26,
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: isIncrement ? primaryRed : blueDeep,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          size: 24,
          color: isIncrement ? primaryRed : blueDeep,
        ),
      ),
    );
  }
}
