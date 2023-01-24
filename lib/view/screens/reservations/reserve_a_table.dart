import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/data/model/response/table_model.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/table_cell_widget.dart';

class ReserveTableScreen extends StatefulWidget {
  final String restaurantID;
  final Function onClickBack;
  const ReserveTableScreen({
    Key key,
    this.restaurantID,
    this.onClickBack,
  }) : super(key: key);
  @override
  State<ReserveTableScreen> createState() => _ReserveTableScreenState();
}

class _ReserveTableScreenState extends State<ReserveTableScreen> {
  List<TableModel> tables = [];
  var isLoading = false;

  Future<void> getTablesList() async {
    setState(() {
      isLoading = true;
    });
    await Get.find<ReservationController>().getTableList(
      widget.restaurantID,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTablesList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReservationController>(builder: (reservationController) {
      tables = [];
      if (reservationController.allTables != null &&
          reservationController.allTables.isNotEmpty) {
        tables.addAll(reservationController.allTables);
      }
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).viewPadding.top + 60,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[Get.isDarkMode ? 800 : 200],
                          spreadRadius: 1,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 24,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Tables'.tr,
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 48,
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          if (tables.isNotEmpty)
                            TableCellWidget(
                              tableModels: tables,
                              onClickChoose: (selIndex) {
                                Get.find<ReservationController>()
                                    .setTableInfo(selIndex);
                                widget.onClickBack();
                                Get.back();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isLoading)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Checking guest info...',
                        style: robotoMedium.copyWith(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
