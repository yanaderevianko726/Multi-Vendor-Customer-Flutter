class ReservationModel {
  int id;
  int reserveType;
  int venueId;
  int chefId;
  int customerId;
  int tableId;
  int orderId;
  String numberInParty;
  String deviceId;
  String venueName;
  String orderName;
  String chefName;
  String chefPhone;
  String customerName;
  String customerEmail;
  String customerPhone;
  String venueAddress;
  String specialNotes;
  String description;
  String reserveDate;
  String startTime;
  String endTime;
  String duration;
  int paymentMethod;
  int status;
  int reserveStatus;
  String paymentStatus;
  double price;
  String tableImage;
  String tableName;

  ReservationModel({
    this.id = 0,
    this.reserveType = 0,
    this.venueId = 0,
    this.chefId = 0,
    this.customerId = 0,
    this.tableId = -1,
    this.orderId = 0,
    this.deviceId = '',
    this.numberInParty = '1',
    this.venueName = '',
    this.orderName = '#',
    this.chefName = '',
    this.chefPhone = '',
    this.customerName = '',
    this.customerEmail = '',
    this.customerPhone = '',
    this.venueAddress = '',
    this.specialNotes = '',
    this.description = '',
    this.reserveDate = '',
    this.startTime = '',
    this.endTime = '',
    this.status = 1,
    this.duration = '',
    this.paymentMethod = 1,
    this.reserveStatus = 0,
    this.paymentStatus = 'unpaid',
    this.price = 0,
    this.tableImage = '',
    this.tableName = '',
  });

  ReservationModel copyWith({
    int id,
    int reserveType,
    int venueId,
    int chefId,
    int customerId,
    int tableId,
    int orderId,
    int deviceId,
    int numberInParty,
    String venueName,
    String orderName,
    String chefName,
    String chefPhone,
    String customerName,
    String customerEmail,
    String customerPhone,
    String venueAddress,
    String specialNotes,
    String description,
    String reserveDate,
    String startTime,
    String endTime,
    int duration,
    int paymentMethod,
    int status,
    int reserveStatus,
    String paymentStatus,
    double price,
    String tableImage,
    String tableName,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      reserveType: reserveType ?? this.reserveType,
      venueId: venueId ?? this.venueId,
      chefId: chefId ?? this.chefId,
      customerId: customerId ?? this.customerId,
      tableId: tableId ?? this.tableId,
      orderId: orderId ?? this.orderId,
      deviceId: deviceId ?? this.deviceId,
      numberInParty: numberInParty ?? this.numberInParty,
      venueName: venueName ?? this.venueName,
      orderName: orderName ?? this.orderName,
      chefName: chefName ?? this.chefName,
      chefPhone: chefPhone ?? this.chefPhone,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      venueAddress: venueAddress ?? this.venueAddress,
      specialNotes: specialNotes ?? this.specialNotes,
      description: description ?? this.description,
      reserveDate: reserveDate ?? this.reserveDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      reserveStatus: reserveStatus ?? this.reserveStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      price: price ?? this.price,
      tableImage: tableImage ?? this.tableImage,
      tableName: tableName ?? this.tableName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'reserve_type': this.reserveType,
      'venue_id': this.venueId,
      'chef_id': this.chefId,
      'customer_id': this.customerId,
      'table_id': this.tableId,
      'order_id': this.orderId,
      'device_id': this.deviceId,
      'number_in_party': this.numberInParty,
      'venue_name': this.venueName,
      'order_name': this.orderName,
      'chef_name': this.chefName,
      'chef_phone': this.chefPhone,
      'customer_name': this.customerName,
      'customer_email': this.customerEmail,
      'customer_phone': this.customerPhone,
      'venue_address': this.venueAddress,
      'special_notes': this.specialNotes,
      'description': this.description,
      'reserve_date': this.reserveDate,
      'start_time': this.startTime,
      'end_time': this.endTime,
      'duration': this.duration,
      'payment_method': this.paymentMethod,
      'status': this.status,
      'reserve_status': this.reserveStatus,
      'payment_status': this.paymentStatus,
      'price': this.price,
      'table_image': this.tableImage,
      'table_name': this.tableName,
    };
  }

  factory ReservationModel.fromJson(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'] as int,
      reserveType: map['reserve_type'] as int,
      venueId: map['venue_id'] as int,
      chefId: map['chef_id'] as int,
      customerId: map['customer_id'] as int,
      tableId: map['table_id'] as int,
      orderId: map['order_id'] as int,
      deviceId: map['device_id'] as String,
      numberInParty: map['number_in_party'] as String,
      venueName: map['venue_name'] as String,
      orderName: map['order_name'] as String,
      chefName: map['chef_name'] as String,
      chefPhone: map['chef_phone'] as String,
      customerName: map['customer_name'] as String,
      customerEmail: map['customer_email'] as String,
      customerPhone: map['customer_phone'] as String,
      venueAddress: map['venue_address'] as String,
      specialNotes: map['special_notes'] as String,
      description: map['description'] as String,
      reserveDate: map['reserve_date'] as String,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      duration: map['duration'] as String,
      paymentMethod: map['payment_method'] as int,
      status: map['status'] as int,
      reserveStatus: map['reserve_status'] as int,
      paymentStatus: map['payment_status'] as String,
      price: double.parse(map['price']),
      tableImage: map['table_image'] as String,
      tableName: map['table_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['venue_id'] = this.venueId;
    data['chef_id'] = this.chefId;
    data['customer_id'] = this.customerId;
    data['table_id'] = this.tableId;
    data['order_id'] = this.orderId;
    data['device_id'] = this.deviceId;
    data['number_in_party'] = this.numberInParty;
    data['venue_name'] = this.venueName;
    data['order_name'] = this.orderName;
    data['chef_name'] = this.chefName;
    data['chef_phone'] = this.chefPhone;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone'] = this.customerPhone;
    data['venue_address'] = this.venueAddress;
    data['special_notes'] = this.specialNotes;
    data['description'] = this.description;
    data['reserve_date'] = this.reserveDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['status'] = this.status;
    data['reserve_status'] = this.reserveStatus;
    data['reserve_type'] = this.reserveType;
    data['price'] = this.price;
    data['table_image'] = this.tableImage;
    data['table_name'] = this.tableName;
    return data;
  }
}
