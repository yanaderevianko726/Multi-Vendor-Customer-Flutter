import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/venues_list_widget.dart';

class OthersVenuesView extends StatefulWidget {
  final String topTitle;
  final int tagIndex;
  final List<Restaurant> venues;
  final Function onCLickViewAll;

  const OthersVenuesView({
    Key key,
    this.topTitle,
    this.tagIndex,
    this.venues,
    this.onCLickViewAll,
  }) : super(key: key);
  @override
  State<OthersVenuesView> createState() => _OthersVenuesViewState();
}

class _OthersVenuesViewState extends State<OthersVenuesView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 6),
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              SizedBox(
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
                              InkWell(
                                onTap: () {
                                  widget.onCLickViewAll();
                                },
                                child: Container(
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: VenuesListWidget(
                              tagIndex: widget.tagIndex,
                              restaurants: widget.venues,
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
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
