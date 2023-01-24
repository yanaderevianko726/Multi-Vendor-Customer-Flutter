import 'package:efood_multivendor/data/model/body/place_order_body.dart';

class FoodOrderModel {
  int id;
  int reservationId;
  int venueId;
  int tableId;
  String orderNumber;
  String orderStatus;
  String orderDate;
  List<Cart> foods;
  String addons;
  String specialInstruction;
  int voucherAvailable;
  int serverTip;
  int serverTipAmount;
  int serverTipMethod;
  double subTotal;
  double tax;
  double serviceCharge;
  double total;
  int promo;
  int paymentMethod;
  int status;
  String failed;
  String transactionReference;
  String paymentStatus;
  String confirmed;
  String createdAt;
  String updatedAt;

  FoodOrderModel({
    this.id,
    this.reservationId,
    this.venueId,
    this.tableId,
    this.orderNumber,
    this.orderStatus,
    this.orderDate,
    this.foods,
    this.addons,
    this.specialInstruction,
    this.voucherAvailable,
    this.serverTip,
    this.serverTipAmount,
    this.serverTipMethod,
    this.subTotal,
    this.tax,
    this.serviceCharge,
    this.total,
    this.promo,
    this.paymentMethod,
    this.status,
    this.failed,
    this.transactionReference,
    this.paymentStatus,
    this.confirmed,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodOrderModel.fromMap(Map<String, dynamic> map) {
    List<Cart> _foods = [];
    if (map['cart'] != null) {
      _foods = [];
      map['cart'].forEach((v) {
        _foods.add(new Cart.fromJson(v));
      });
    }

    return FoodOrderModel(
      id: map['id'] as int,
      reservationId: map['reservation_id'] as int,
      venueId: map['venue_id'] as int,
      tableId: map['table_id'] as int,
      orderNumber: map['order_number'] as String,
      orderStatus: map['order_status'] as String,
      orderDate: map['order_date'] as String,
      foods: _foods,
      addons: map['addons'] as String,
      specialInstruction: map['special_instruction'] as String,
      voucherAvailable: map['voucher_available'] as int,
      serverTip: map['server_tip'] as int,
      serverTipAmount: map['server_tip_amount'] as int,
      serverTipMethod: map['server_tip_method'] as int,
      subTotal: map['sub_total'] as double,
      tax: map['tax'] as double,
      serviceCharge: map['service_charge'] as double,
      total: map['total'] as double,
      promo: map['promo'] as int,
      paymentMethod: map['payment_method'] as int,
      status: map['status'] as int,
      failed: map['failed'] as String,
      transactionReference: map['transaction_reference'] as String,
      paymentStatus: map['payment_status'] as String,
      confirmed: map['confirmed'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  FoodOrderModel copyWith({
    int id,
    int reservationId,
    int venueId,
    int tableId,
    String orderNumber,
    String orderStatus,
    String orderDate,
    String foods,
    String addons,
    String specialInstruction,
    int voucherAvailable,
    int serverTip,
    int serverTipAmount,
    int serverTipMethod,
    double subTotal,
    double tax,
    double serviceCharge,
    double total,
    int promo,
    int paymentMethod,
    int status,
    String failed,
    String transactionReference,
    String paymentStatus,
    String confirmed,
    String createdAt,
    String updatedAt,
  }) {
    return FoodOrderModel(
      id: id ?? this.id,
      reservationId: reservationId ?? this.reservationId,
      venueId: venueId ?? this.venueId,
      tableId: tableId ?? this.tableId,
      orderNumber: orderNumber ?? this.orderNumber,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      foods: foods ?? this.foods,
      addons: addons ?? this.addons,
      specialInstruction: specialInstruction ?? this.specialInstruction,
      voucherAvailable: voucherAvailable ?? this.voucherAvailable,
      serverTip: serverTip ?? this.serverTip,
      serverTipAmount: serverTipAmount ?? this.serverTipAmount,
      serverTipMethod: serverTipMethod ?? this.serverTipMethod,
      subTotal: subTotal ?? this.subTotal,
      tax: tax ?? this.tax,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      total: total ?? this.total,
      promo: promo ?? this.promo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      failed: failed ?? this.failed,
      transactionReference: transactionReference ?? this.transactionReference,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      confirmed: confirmed ?? this.confirmed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foods != null) {
      data['foods'] = this.foods.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['reservation_id'] = this.reservationId;
    data['venue_id'] = this.venueId;
    data['table_id'] = this.tableId;
    data['order_number'] = this.orderNumber;
    data['order_status'] = this.orderStatus;
    data['order_date'] = this.orderDate;
    data['foods'] = this.foods;
    data['addons'] = this.addons;
    data['special_instruction'] = this.specialInstruction;
    data['voucher_available'] = this.voucherAvailable;
    data['server_tip'] = this.serverTip;
    data['server_tip_amount'] = this.serverTipAmount;
    data['server_tip_method'] = this.serverTipMethod;
    data['tax'] = this.tax;
    data['service_charge'] = this.serviceCharge;
    data['total'] = this.total;
    data['promo'] = this.promo;
    data['payment_method'] = this.paymentMethod;
    data['status'] = this.status;
    data['failed'] = this.failed;
    data['transaction_reference'] = this.transactionReference;
    data['payment_status'] = this.paymentStatus;
    data['confirmed'] = this.confirmed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
