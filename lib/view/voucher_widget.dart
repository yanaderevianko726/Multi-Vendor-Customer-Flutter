import 'dart:math';

import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class VoucherUIModel {
  String id;
  String userId;
  String type;
  String balance;
  String desc;
  String image;

  VoucherUIModel({
    this.id = '',
    this.userId = '',
    this.type = '',
    this.balance = '0',
    this.desc = '',
    this.image = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "userId": this.userId,
      "type": this.type,
      "desc": this.desc,
      "balance": this.balance,
      "image": this.image,
    };
  }

  factory VoucherUIModel.fromLocalJson(Map<String, dynamic> json) {
    return VoucherUIModel(
      id: json["id"],
      userId: json["userId"],
      type: json["type"],
      balance: json["balance"],
      desc: json["desc"],
      image: json["image"],
    );
  }

  factory VoucherUIModel.fromServerJson(Map<String, dynamic> json) {
    return VoucherUIModel(
      id: json["sc_id"],
      userId: json["userId"],
      type: json["type"],
      balance: json["balance"],
      desc: json["desc"],
      image: json["image"],
    );
  }

  Widget getListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15.5,
            child: Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, orangeLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white54,
                      offset: Offset(0, 0),
                      blurRadius: 5,
                      spreadRadius: 3,
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: image == ''
                    ? Image.asset(
                        image,
                        color: Colors.white,
                      )
                    : SizedBox(),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 21.5,
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.double_arrow,
                size: 14.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21.5, right: 16),
            child: ClipPath(
              clipper: CategoryClipper(),
              child: Container(
                width: double.infinity,
                height: 75.0,
                padding: EdgeInsets.only(left: 12, top: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.5),
                      orangeLight.withOpacity(0.5)
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      balance,
                      style: robotoMedium.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${balance != null ? balance : '---'}',
                          style: robotoMedium.copyWith(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Path categoryPath({
  @required Size size,
}) {
  const radius = 8.0;
  const iconLg = 52.0;
  const iconSm = 36.0;

  var path = Path();
  path.moveTo(0, radius);
  path.lineTo(0, (size.height - iconLg) * 0.5);
  path.arcToPoint(
    Offset(0, (size.height + iconLg) * 0.5),
    radius: Radius.circular(iconLg * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.lineTo(0, size.height - radius);
  path.quadraticBezierTo(
    0,
    size.height,
    radius,
    size.height,
  );
  path.lineTo(size.width - radius, size.height);
  path.quadraticBezierTo(
      size.width, size.height, size.width, size.height - radius);
  path.lineTo(size.width, (size.height + iconSm) * 0.5);
  path.arcToPoint(
    Offset(size.width, (size.height - iconSm) * 0.5),
    radius: Radius.circular(iconSm * 0.5),
    rotation: pi,
    clockwise: true,
  );
  path.lineTo(size.width, radius);
  path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
  path.lineTo(radius, 0);
  path.quadraticBezierTo(0, 0, 0, radius);
  path.close();

  return path;
}

class CategoryClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = categoryPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class CategoryShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = categoryPath(size: size);
    canvas.drawShadow(path, Colors.white, 2.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
