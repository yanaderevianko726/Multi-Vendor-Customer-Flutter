import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/swushd_premium/widgets/premium_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherPremiumsView extends StatefulWidget {
  final String topTitle;
  final int tagIndex;
  final List<Restaurant> otherVenues;
  final Function onCLickViewAll;

  const OtherPremiumsView({
    Key key,
    this.topTitle,
    this.otherVenues,
    this.onCLickViewAll,
    this.tagIndex = 0,
  }) : super(key: key);
  @override
  State<OtherPremiumsView> createState() => _OtherPremiumsViewState();
}

class _OtherPremiumsViewState extends State<OtherPremiumsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 12,
              top: 6,
              right: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.topTitle}',
                      style: robotoMedium.copyWith(fontSize: 16),
                    ),
                    Spacer(),
                    Container(
                      child: Center(
                        child: Text(
                          '${'View All'.tr}',
                          style: robotoMedium.copyWith(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: PremiumListWidget(
                    tagIndex: widget.tagIndex,
                    restaurants: widget.otherVenues,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
