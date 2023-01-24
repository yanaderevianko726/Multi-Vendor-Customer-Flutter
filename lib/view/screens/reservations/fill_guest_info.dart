import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FillGuestInfoScreen extends StatefulWidget {
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final Function onClickNext;

  const FillGuestInfoScreen({
    Key key,
    this.guestName,
    this.guestPhone,
    this.guestEmail,
    this.onClickNext,
  }) : super(key: key);
  @override
  State<FillGuestInfoScreen> createState() => _FillGuestInfoScreenState();
}

class _FillGuestInfoScreenState extends State<FillGuestInfoScreen> {
  final FocusNode _guestNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _startTimeFocus = FocusNode();
  final FocusNode _endTimeFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _numberInPartyFocus = FocusNode();
  final FocusNode _specialFocus = FocusNode();
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _numberInPartyController =
      TextEditingController();
  final TextEditingController _specialNoteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _guestNameController.text = '';
    _emailController.text = '';
    _phoneController.text = '';

    if (Get.find<UserController>().userInfoModel != null) {
      _guestNameController.text =
          Get.find<UserController>().userInfoModel.fName ?? '';
      _emailController.text =
          Get.find<UserController>().userInfoModel.email ?? '';
      _phoneController.text =
          Get.find<UserController>().userInfoModel.phone ?? '';
    } else {
      Get.find<UserController>().getUserInfo().then((value) {
        if (value.isSuccess) {
          _guestNameController.text =
              Get.find<UserController>().userInfoModel.fName ?? '';
          _emailController.text =
              Get.find<UserController>().userInfoModel.email ?? '';
          _phoneController.text =
              Get.find<UserController>().userInfoModel.phone ?? '';
        }
      });
    }

    _dateController.text =
        Get.find<ReservationController>().reservation.reserveDate;
    _startTimeController.text =
        Get.find<ReservationController>().reservation.startTime;
    _endTimeController.text =
        Get.find<ReservationController>().reservation.endTime;
    _numberInPartyController.text =
        Get.find<ReservationController>().reservation.numberInParty;
    _specialNoteCtrl.text =
        Get.find<ReservationController>().reservation.specialNotes;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_LARGE,
          horizontal: 4,
        ),
        width: Dimensions.WEB_MAX_WIDTH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${'Guest Name'.tr}',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Text(
                  '  (${'Do not allowed change'.tr})',
                  style: robotoRegular.copyWith(
                    fontSize: 11,
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                color: Theme.of(context).disabledColor.withOpacity(0.3),
                child: MyTextField(
                  hintText: 'Guest Name'.tr,
                  controller: _guestNameController,
                  focusNode: _guestNameFocus,
                  nextFocus: _emailFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                  fillColor: Colors.transparent,
                  isEnabled: false,
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_SMALL,
            ),
            Row(
              children: [
                Text(
                  '${'email'.tr}',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Text(
                  '  (${'Do not allowed change'.tr})',
                  style: robotoRegular.copyWith(
                    fontSize: 11,
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                color: Theme.of(context).disabledColor.withOpacity(0.3),
                child: MyTextField(
                  hintText: 'email'.tr,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  nextFocus: _phoneFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.emailAddress,
                  fillColor: Colors.transparent,
                  isEnabled: false,
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_SMALL,
            ),
            Row(
              children: [
                Text(
                  '${'phone'.tr}',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Text(
                  '  (${'Do not allowed change'.tr})',
                  style: robotoRegular.copyWith(
                    fontSize: 11,
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                color: Theme.of(context).disabledColor.withOpacity(0.3),
                child: MyTextField(
                  hintText: 'phone'.tr,
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  nextFocus: _dateFocus,
                  inputType: TextInputType.phone,
                  fillColor: Colors.transparent,
                  isEnabled: false,
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_SMALL,
            ),
            Text(
              '${'Date'.tr} (Day / Month / Year)',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).disabledColor,
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                color: Theme.of(context).disabledColor.withOpacity(0.3),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: 'Date'.tr,
                        controller: _dateController,
                        focusNode: _dateFocus,
                        nextFocus: _startTimeFocus,
                        inputType: TextInputType.phone,
                        isEnabled: false,
                        fillColor: Colors.transparent,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print('=== pickDate: $formattedDate');
                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL + 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 72,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            '${'Start Time'.tr} (HH:MM)',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.3),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      hintText: 'Start Time'.tr,
                                      controller: _startTimeController,
                                      focusNode: _startTimeFocus,
                                      nextFocus: _endTimeFocus,
                                      inputType: TextInputType.phone,
                                      isEnabled: false,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final TimeOfDay newTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: DateTime.now().hour,
                                          minute: DateTime.now().minute,
                                        ),
                                      );
                                      if (newTime != null) {
                                        _startTimeController.text =
                                            '${newTime.hour >= 10 ? newTime.hour : '0${newTime.hour}'}:${newTime.minute >= 10 ? newTime.minute : '0${newTime.minute}'}';
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                      ),
                                      child: Icon(
                                        Icons.access_time,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            '${'End Time'.tr} (HH:MM)',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.3),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      hintText: 'End Time'.tr,
                                      controller: _endTimeController,
                                      focusNode: _endTimeFocus,
                                      nextFocus: _numberInPartyFocus,
                                      inputType: TextInputType.phone,
                                      isEnabled: false,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final TimeOfDay newTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: DateTime.now().hour,
                                          minute: DateTime.now().minute,
                                        ),
                                      );
                                      if (newTime != null) {
                                        _endTimeController.text =
                                            '${newTime.hour >= 10 ? newTime.hour : '0${newTime.hour}'}:${newTime.minute >= 10 ? newTime.minute : '0${newTime.minute}'}';
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                      ),
                                      child: Icon(
                                        Icons.access_time,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_SMALL,
            ),
            Text(
              'Number in Party'.tr,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).disabledColor,
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                color: Theme.of(context).disabledColor.withOpacity(0.3),
                child: MyTextField(
                  hintText: 'Number in Party'.tr,
                  controller: _numberInPartyController,
                  focusNode: _numberInPartyFocus,
                  nextFocus: _specialFocus,
                  inputType: TextInputType.phone,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_SMALL,
            ),
            Text(
              'Special Notes'.tr,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).disabledColor,
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                color: Theme.of(context).disabledColor.withOpacity(0.3),
                child: MyTextField(
                  hintText: 'Special Notes'.tr,
                  controller: _specialNoteCtrl,
                  focusNode: _specialFocus,
                  inputType: TextInputType.emailAddress,
                  fillColor: Colors.transparent,
                  maxLines: 5,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                var chk = checkEmptyAndValid();
                if (chk == '') {
                  Get.find<ReservationController>().setReserveTime(
                    '${_dateController.text}',
                    '${_startTimeController.text}',
                    '${_endTimeController.text}',
                  );
                  Get.find<ReservationController>().setReserveOptions(
                    '${_numberInPartyController.text}',
                    '${_specialNoteCtrl.text}',
                  );

                  widget.onClickNext(
                    _guestNameController.text,
                    _emailController.text,
                    _phoneController.text,
                  );
                } else {
                  showCustomSnackBar(chk, isError: false);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 44,
                margin: EdgeInsets.symmetric(
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Confirm'.tr,
                    style: robotoMedium.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String checkEmptyAndValid() {
    var chk = '';
    if (_guestNameController.text.isEmpty) {
      chk = 'Please enter guest name'.tr;
    } else if (_emailController.text.isEmpty) {
      chk = 'Please enter email'.tr;
    } else if (_phoneController.text.isEmpty) {
      chk = 'Please enter a phone number'.tr;
    } else if (_dateController.text.isEmpty) {
      chk = 'Please select date of reservation'.tr;
    } else if (_startTimeController.text.isEmpty) {
      chk = 'Please select start time for reservation'.tr;
    } else if (_endTimeController.text.isEmpty) {
      chk = 'Please select end time for reservation'.tr;
    } else if (_numberInPartyController.text.isEmpty) {
      chk = 'Please fill guests number in party.'.tr;
    } else if (_specialNoteCtrl.text.isEmpty) {
      chk = 'Please fill special notes.'.tr;
    } else {
      final curDate = DateTime.now();
      int curY = curDate.year;
      int curM = curDate.month;
      int curD = curDate.day;
      int curHH = curDate.hour;
      int curMM = curDate.minute;

      var hm = _startTimeController.text.split(':');
      int sH = int.parse(hm[0]);
      int sM = int.parse(hm[1]);

      var hm1 = _endTimeController.text.split(':');
      int eH = int.parse(hm1[0]);
      int eM = int.parse(hm1[1]);

      var d1 = _dateController.text.split('-');
      int rDay = int.parse(d1[2]);
      int rMonth = int.parse(d1[1]);
      int rYear = int.parse(d1[0]);

      if (rYear == curY) {
        if (rMonth == curM) {
          if (rDay == curD) {
            if (sH >= curHH) {
              if (sH == curHH && sM < curMM) {
                chk = 'Reserve minute can not be less than current minute.'.tr;
              } else {
                final startTime = DateTime(rYear, rMonth, rDay, sH, sM);
                final endTime = DateTime(rYear, rMonth, rDay, eH, eM);
                final difference = startTime.difference(endTime).inMinutes;
                print('=== timeDifference: $difference');
                if (difference >= 0) {
                  chk = 'End time can not be equal or less than start time.'.tr;
                }
              }
            } else {
              chk = 'Reserve hour can not be less than current hour.'.tr;
            }
          } else {
            if (rDay < curD) {
              chk = 'Reserve day can not be less than current day.'.tr;
            }
          }
        } else {
          chk = 'Please select current month.'.tr;
        }
      } else {
        chk = 'Please select current year'.tr;
      }
    }
    return chk;
  }
}
