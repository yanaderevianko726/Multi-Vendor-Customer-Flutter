import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingSimplified extends StatelessWidget {
  final double rating;
  final double size;
  final int ratingCount;

  RatingSimplified({
    @required this.rating,
    @required this.ratingCount,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _starList = [];
    _starList.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Icon(
          Icons.star,
          color: Theme.of(context).primaryColor,
          size: size + 2,
        ),
      ),
    );

    double _ratingCount = 0;
    var ratingDisp = '$_ratingCount Reviews';
    if (ratingCount != null) {
      ratingDisp = '$ratingCount Reviews';
      if (ratingCount >= 1000 && ratingCount < 1000000) {
        _ratingCount = (ratingCount / 1000).toPrecision(1);
        ratingDisp = '$_ratingCount k Reviews';
      } else if (ratingCount >= 1000000) {
        _ratingCount = (ratingCount / 1000000).toPrecision(1);
        ratingDisp = '$_ratingCount M Reviews';
      }
    }
    ratingCount != null
        ? _starList.add(
            Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: Text(
                '${rating.toPrecision(1)} ($ratingDisp)',
                style: robotoRegular.copyWith(
                  fontSize: size * 0.8,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
          )
        : SizedBox();

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _starList,
      ),
    );
  }
}
