class UserInfoModel {
  int id;
  String fName;
  String lName;
  String email;
  String image;
  String phone;
  String password;
  int orderCount;
  int memberSinceDays;
  double walletBalance;
  int loyaltyPoint;
  int isGuest;
  String refCode;
  String deviceId;

  UserInfoModel({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.image,
    this.phone,
    this.password,
    this.orderCount,
    this.memberSinceDays,
    this.walletBalance,
    this.loyaltyPoint,
    this.isGuest,
    this.refCode,
    this.deviceId,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    phone = '${json['phone']}';
    password = json['password'];
    orderCount = json['order_count'];
    memberSinceDays = json['member_since_days'];
    walletBalance = json['wallet_balance'] != null
        ? double.parse('${json['wallet_balance']}')
        : 0.0;
    loyaltyPoint = json['loyalty_point'];
    isGuest = json['is_guest'];
    refCode = json['ref_code'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['order_count'] = this.orderCount;
    data['member_since_days'] = this.memberSinceDays;
    data['wallet_balance'] = this.walletBalance;
    data['loyalty_point'] = this.loyaltyPoint;
    data['is_guest'] = this.isGuest;
    data['ref_code'] = this.refCode;
    data['device_id'] = this.deviceId;
    return data;
  }

  void setEmptyInfo() {
    fName = '';
    lName = '';
    email = '';
    image = '';
    phone = '';
    password = '';
    orderCount = 0;
    memberSinceDays = 0;
    walletBalance = 0;
    loyaltyPoint = 0;
    isGuest = 0;
    refCode = '';
    deviceId = '';
  }

  UserInfoModel copyWith({
    int id,
    String fName,
    String lName,
    String email,
    String image,
    String phone,
    String password,
    int orderCount,
    int memberSinceDays,
    double walletBalance,
    int loyaltyPoint,
    String isGuest,
    String refCode,
    String deviceId,
  }) {
    return UserInfoModel(
      id: id ?? this.id,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      email: email ?? this.email,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      orderCount: orderCount ?? this.orderCount,
      memberSinceDays: memberSinceDays ?? this.memberSinceDays,
      walletBalance: walletBalance ?? this.walletBalance,
      loyaltyPoint: loyaltyPoint ?? this.loyaltyPoint,
      isGuest: isGuest ?? this.isGuest,
      refCode: refCode ?? this.refCode,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
