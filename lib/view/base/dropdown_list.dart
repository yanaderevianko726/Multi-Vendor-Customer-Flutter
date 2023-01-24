import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  final List<String> titles;
  final Function onChanged;
  const MyStatefulWidget({
    Key key,
    this.titles,
    this.onChanged,
  }) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(
        Icons.arrow_drop_down,
        color: yellowDark,
      ),
      elevation: 3,
      style: robotoRegular.copyWith(
        fontSize: 16,
        color: Colors.black87.withOpacity(0.7),
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
        widget.onChanged(newValue);
      },
      items: widget.titles.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: robotoRegular.copyWith(
              fontSize: 15,
              color: value == dropdownValue
                  ? yellowDark
                  : Colors.black87.withOpacity(0.7),
            ),
          ),
        );
      }).toList(),
    );
  }
}
