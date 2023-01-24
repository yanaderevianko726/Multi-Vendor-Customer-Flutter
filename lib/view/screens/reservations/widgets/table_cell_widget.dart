import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/table_model.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableCellWidget extends StatefulWidget {
  final List<TableModel> tableModels;
  final Function onClickChoose;
  const TableCellWidget({
    Key key,
    this.tableModels,
    this.onClickChoose,
  }) : super(key: key);
  @override
  State<TableCellWidget> createState() => _TableCellWidgetState();
}

class _TableCellWidgetState extends State<TableCellWidget> {
  var selIndex = -1;
  @override
  Widget build(BuildContext context) {
    BaseUrls baseUrls = Get.find<SplashController>().configModel.baseUrls;
    return Column(
      children: [
        for (int i = 0; i < widget.tableModels.length; i++)
          tableCellUI(
            onTap: () {
              setState(() {
                selIndex = i;
              });
            },
            selIndex: selIndex,
            currentIndex: i,
            tableModel: widget.tableModels[i],
            baseUrls: baseUrls,
            context: context,
          ),
        InkWell(
          onTap: () {
            if (selIndex != -1) {
              widget.onClickChoose(selIndex);
            } else {
              showCustomSnackBar('Please take a table.'.tr, isError: false);
            }
          },
          child: Container(
            height: 48,
            margin: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                'Choose'.tr,
                style: robotoMedium.copyWith(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget tableCellUI({
  Function onTap,
  int selIndex = -1,
  int currentIndex,
  TableModel tableModel,
  BaseUrls baseUrls,
  BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 4,
    ),
    child: InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        elevation: 3,
        color: selIndex == currentIndex
            ? Theme.of(context).cardColor.withOpacity(0.8)
            : Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      '${tableModel.tableName}',
                      style: robotoMedium.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    if (selIndex == currentIndex)
                      Image.asset(
                        'assets/image/checked.png',
                        width: 18,
                        fit: BoxFit.fitWidth,
                      ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      child: CustomImage(
                        image: '${baseUrls.tablesImageUrl}'
                            '/${tableModel.image}',
                        width: 100,
                        height: 92,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              '${'Table Name'.tr}:',
                              style: robotoMedium.copyWith(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                '${tableModel.tableName}',
                                style: robotoMedium.copyWith(
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              '${'Capacity'.tr}:',
                              style: robotoMedium.copyWith(
                                fontSize: 15,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${tableModel.capacity}',
                              style: robotoMedium.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              '${'Floor'.tr}:',
                              style: robotoMedium.copyWith(
                                fontSize: 15,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${tableModel.floorNumber}',
                              style: robotoMedium.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  bottom: 8,
                  top: 12,
                ),
                child: DottedLine(
                  dashColor: Theme.of(context).disabledColor,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Schedule Status: '.tr,
                      style: robotoMedium,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        if (tableModel.schedules.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              top: 4.0,
                            ),
                            child: Text(
                              'There is no any schedules for this table'.tr,
                              style: robotoRegular.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        for (int j = 0; j < tableModel.schedules.length; j++)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${tableModel.schedules[j].reserveDate}: ',
                                  style: robotoRegular,
                                ),
                                Text(
                                  '${tableModel.schedules[j].startTime} ~ ',
                                  style: robotoRegular,
                                ),
                                Text(
                                  '${tableModel.schedules[j].endTime}',
                                  style: robotoRegular,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
