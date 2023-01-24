class Vendor {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String image;
  int status;
  int vFeatured;
  int vTrending;
  int vIsNew;
  int vendorType;
  int celebCategory;
  int priority;
  int restaurantId;
  int cuisineId;

  Vendor({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.image,
    this.phone,
    this.status,
    this.vFeatured,
    this.vTrending,
    this.vIsNew,
    this.vendorType,
    this.celebCategory,
    this.priority,
    this.restaurantId,
    this.cuisineId,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    print('=== vendorJson: ${json.toString()}');
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    status = json['status'];
    vFeatured = json['v_featured'] ?? 0;
    vTrending = json['v_trending'] ?? 0;
    vIsNew = json['v_isNew'] ?? 0;
    vendorType = json['vendor_type'] ?? 0;
    celebCategory = json['celeb_category'] ?? 0;
    priority = json['priority'];
    restaurantId = json['restaurant_id'];
    cuisineId = json['cuisine_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['v_featured'] = this.vFeatured;
    data['v_trending'] = this.vTrending;
    data['v_isNew'] = this.vIsNew;
    data['vendor_type'] = this.vendorType;
    data['celeb_category'] = this.celebCategory;
    data['priority'] = this.priority;
    data['restaurant_id'] = this.restaurantId;
    data['cuisine_id'] = this.cuisineId;
    return data;
  }

  Vendor copyWith({
    int id,
    String fName,
    String lName,
    String phone,
    String email,
    String image,
    int status,
    int vFeatured,
    int vTrending,
    int vIsNew,
    int vendorType,
    int celebCategory,
    int priority,
    int restaurantId,
    int cuisineId,
  }) {
    return Vendor(
      id: id ?? this.id,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      image: image ?? this.image,
      status: status ?? this.status,
      vFeatured: vFeatured ?? this.vFeatured,
      vTrending: vTrending ?? this.vTrending,
      vIsNew: vIsNew ?? this.vIsNew,
      vendorType: vendorType ?? this.vendorType,
      celebCategory: celebCategory ?? this.celebCategory,
      priority: priority ?? this.priority,
      restaurantId: restaurantId ?? this.restaurantId,
      cuisineId: cuisineId ?? this.cuisineId,
    );
  }
}
