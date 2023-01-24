class RestaurantModel {
  int totalSize;
  int offset;
  String limit;
  List<Restaurant> restaurants;

  RestaurantModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.restaurants,
  }) {
    if (restaurants == null) {
      totalSize = 0;
      limit = '50';
      offset = 1;
      restaurants = [];
    }
  }

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset =
        (json['offset'] != null && json['offset'].toString().trim().isNotEmpty)
            ? int.parse(json['offset'].toString())
            : null;
    if (json['restaurants'] != null) {
      restaurants = [];
      json['restaurants'].forEach((v) {
        restaurants.add(
          new Restaurant.fromJson(v),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  int id;
  String name;
  String phone;
  String email;
  String logo;
  String latitude;
  String longitude;
  int vendorId;
  String address;
  double minimumOrder;
  String currency;
  bool freeDelivery;
  String coverPhoto;
  bool delivery;
  bool takeAway;
  bool scheduleOrder;
  double avgRating;
  double tax;
  int ratingCount;
  int selfDeliverySystem;
  bool posSystem;
  double deliveryCharge;
  int open;
  bool active;
  String deliveryTime;
  List<int> categoryIds;
  int veg;
  int status;
  int nonVeg;
  int featured;
  int trending;
  int isNew;
  int priority;
  int bussinessId;
  int cuisineId;
  int venueType;
  int classify;
  int kindness;
  double serviceCharge;
  double serverTip;
  double promo;
  String featuredImage;
  Discount discount;
  List<Schedules> schedules;

  Restaurant({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.logo,
    this.latitude,
    this.longitude,
    this.address,
    this.vendorId,
    this.minimumOrder,
    this.currency,
    this.freeDelivery,
    this.coverPhoto,
    this.delivery,
    this.takeAway,
    this.scheduleOrder,
    this.avgRating,
    this.tax,
    this.ratingCount,
    this.selfDeliverySystem,
    this.posSystem,
    this.deliveryCharge,
    this.open,
    this.active,
    this.deliveryTime,
    this.categoryIds,
    this.veg,
    this.status,
    this.nonVeg,
    this.featured,
    this.trending,
    this.isNew,
    this.priority,
    this.bussinessId,
    this.cuisineId,
    this.venueType,
    this.classify,
    this.kindness,
    this.serviceCharge,
    this.serverTip,
    this.promo,
    this.featuredImage,
    this.discount,
    this.schedules,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    print('=== restaurantJson: ${json.toString()}');
    print('=== restaurantSchedule: ${json['schedules'] ?? 'null'}');
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'] != null ? json['logo'] : '';
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    vendorId = json['vendor_id'];
    minimumOrder = json['minimum_order'].toDouble();
    freeDelivery = json['free_delivery'];
    coverPhoto = json['cover_photo'] != null ? json['cover_photo'] : '';
    delivery = json['delivery'];
    takeAway = json['take_away'];
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating'].toDouble();
    tax = json['tax'] != null ? json['tax'].toDouble() : null;
    ratingCount = json['rating_count '];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    deliveryCharge = json['delivery_charge'].toDouble();
    open = json['open'];
    active = json['active'];
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    status = json['status'];
    nonVeg = json['non_veg'];
    featured = json['featured'];
    trending = json['trending'];
    isNew = json['isNew'];
    priority = json['priority'];
    venueType = json['venue_type'];
    classify = json['classify'];
    kindness = json['kindness'];
    featuredImage = json['featured_image'];
    bussinessId = json['bussiness_id'];
    cuisineId = json['cuisine_id'];
    serviceCharge = double.parse('${json['service_charge']}');
    serverTip = double.parse('${json['server_tip']}');
    promo = double.parse('${json['promo']}');
    categoryIds =
        json['category_ids'] != null ? json['category_ids'].cast<int>() : [];
    discount = json['discount'] != null
        ? new Discount.fromJson(json['discount'])
        : null;
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules.add(new Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['vendor_id'] = this.vendorId;
    data['minimum_order'] = this.minimumOrder;
    data['currency'] = this.currency;
    data['free_delivery'] = this.freeDelivery;
    data['cover_photo'] = this.coverPhoto;
    data['delivery'] = this.delivery;
    data['take_away'] = this.takeAway;
    data['schedule_order'] = this.scheduleOrder;
    data['avg_rating'] = this.avgRating;
    data['tax'] = this.tax;
    data['rating_count '] = this.ratingCount;
    data['self_delivery_system'] = this.selfDeliverySystem;
    data['pos_system'] = this.posSystem;
    data['delivery_charge'] = this.deliveryCharge;
    data['open'] = this.open;
    data['active'] = this.active;
    data['status'] = this.status;
    data['veg'] = this.veg;
    data['non_veg'] = this.nonVeg;
    data['delivery_time'] = this.deliveryTime;
    data['category_ids'] = this.categoryIds;
    data['featured'] = this.featured;
    data['trending'] = this.trending;
    data['isNew'] = this.isNew;
    data['priority'] = this.priority;
    data['venue_type'] = this.venueType;
    data['classify'] = this.classify;
    data['kindness'] = this.kindness;
    data['featured_image'] = this.featuredImage;
    data['bussiness_id'] = this.bussinessId;
    data['cuisine_id'] = this.cuisineId;
    data['service_charge'] = this.serviceCharge;
    data['server_tip'] = this.serverTip;
    data['promo'] = this.promo;
    if (this.discount != null) {
      data['discount'] = this.discount.toJson();
    }
    if (this.schedules != null) {
      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Restaurant copyWith({
    int id,
    String name,
    String phone,
    String email,
    String logo,
    String latitude,
    String longitude,
    int vendorId,
    String address,
    double minimumOrder,
    String currency,
    bool freeDelivery,
    String coverPhoto,
    bool delivery,
    bool takeAway,
    bool scheduleOrder,
    double avgRating,
    double tax,
    int ratingCount,
    int selfDeliverySystem,
    bool posSystem,
    double deliveryCharge,
    int open,
    bool active,
    String deliveryTime,
    List<int> categoryIds,
    int veg,
    int status,
    int nonVeg,
    int featured,
    int trending,
    int isNew,
    int priority,
    int venueType,
    int classify,
    int kindness,
    String featuredImage,
    int bussinessId,
    int cuisineId,
    int serviceCharge,
    int serverTip,
    int promo,
    Discount discount,
    List<Schedules> schedules,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logo: logo ?? this.logo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      vendorId: vendorId ?? this.vendorId,
      address: address ?? this.address,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      currency: currency ?? this.currency,
      freeDelivery: freeDelivery ?? this.freeDelivery,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      delivery: delivery ?? this.delivery,
      takeAway: takeAway ?? this.takeAway,
      scheduleOrder: scheduleOrder ?? this.scheduleOrder,
      avgRating: avgRating ?? this.avgRating,
      tax: tax ?? this.tax,
      ratingCount: ratingCount ?? this.ratingCount,
      selfDeliverySystem: selfDeliverySystem ?? this.selfDeliverySystem,
      posSystem: posSystem ?? this.posSystem,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      open: open ?? this.open,
      active: active ?? this.active,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      categoryIds: categoryIds ?? this.categoryIds,
      veg: veg ?? this.veg,
      status: status ?? this.status,
      nonVeg: nonVeg ?? this.nonVeg,
      featured: featured ?? this.featured,
      trending: trending ?? this.trending,
      isNew: isNew ?? this.isNew,
      priority: priority ?? this.priority,
      venueType: venueType ?? this.venueType,
      classify: classify ?? this.classify,
      kindness: classify ?? this.kindness,
      featuredImage: featuredImage ?? this.featuredImage,
      bussinessId: bussinessId ?? this.bussinessId,
      cuisineId: cuisineId ?? this.cuisineId,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      serverTip: serverTip ?? this.serverTip,
      promo: promo ?? this.promo,
      discount: discount ?? this.discount,
      schedules: schedules ?? this.schedules,
    );
  }
}

class Discount {
  int id;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  double minPurchase;
  double maxDiscount;
  double discount;
  String discountType;
  int restaurantId;
  String createdAt;
  String updatedAt;

  Discount({
    this.id,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.minPurchase,
    this.maxDiscount,
    this.discount,
    this.discountType,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime =
        json['start_time'] != null ? json['start_time'].substring(0, 5) : null;
    endTime =
        json['end_time'] != null ? json['end_time'].substring(0, 5) : null;
    minPurchase = json['min_purchase'].toDouble();
    maxDiscount = json['max_discount'].toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['min_purchase'] = this.minPurchase;
    data['max_discount'] = this.maxDiscount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['restaurant_id'] = this.restaurantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Schedules {
  int id;
  int restaurantId;
  int day;
  String openingTime;
  String closingTime;

  Schedules({
    this.id,
    this.restaurantId,
    this.day,
    this.openingTime,
    this.closingTime,
  });

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['day'] = this.day;
    data['opening_time'] = this.openingTime;
    data['closing_time'] = this.closingTime;
    return data;
  }
}
