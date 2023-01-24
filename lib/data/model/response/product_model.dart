class ProductModel {
  int totalSize;
  String limit;
  int offset;
  List<Product> products;

  ProductModel({this.totalSize, this.limit, this.offset, this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset =
        (json['offset'] != null && json['offset'].toString().trim().isNotEmpty)
            ? int.parse(json['offset'].toString())
            : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int id;
  String name;
  String description;
  String image;
  int categoryId;
  List<CategoryIds> categoryIds;
  List<CuisineIds> cuisineIds;
  List<Variation> variations;
  List<AddOns> addOns;
  List<ChoiceOptions> choiceOptions;
  double price;
  double tax;
  double discount;
  String discountType;
  String availableTimeStarts;
  String availableTimeEnds;
  int restaurantId;
  String restaurantName;
  double restaurantDiscount;
  bool scheduleOrder;
  double avgRating;
  int ratingCount;
  int status;
  int featured;
  int trending;
  int isNew;
  int veg;

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.categoryIds,
    this.cuisineIds,
    this.variations,
    this.addOns,
    this.choiceOptions,
    this.price,
    this.tax,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.restaurantId,
    this.restaurantName,
    this.restaurantDiscount,
    this.scheduleOrder,
    this.avgRating,
    this.ratingCount,
    this.featured,
    this.trending,
    this.isNew,
    this.status,
    this.veg,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds.add(new CategoryIds.fromJson(v));
      });
    }
    cuisineIds = json['cuisine_ids'];
    if (json['cuisine_ids'] != null) {
      cuisineIds = [];
      json['cuisine_ids'].forEach((v) {
        cuisineIds.add(new CuisineIds.fromJson(v));
      });
    }
    if (json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        variations.add(new Variation.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns.add(new AddOns.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      choiceOptions = [];
      print('=== chooseOptions: ${json['choice_options'].toString()}');
      json['choice_options'].forEach((v) {
        choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    price = json['price'].toDouble();
    tax = json['tax'] != null ? json['tax'].toDouble() : null;
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    restaurantDiscount = json['restaurant_discount'].toDouble();
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    status = json['status'];
    featured = json['f_featured'] ?? '';
    trending = json['f_trending'] ?? '';
    isNew = json['f_isNew'] ?? '';
    veg = json['veg'] != null ? int.parse(json['veg'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    if (this.categoryIds != null) {
      data['category_ids'] = this.categoryIds.map((v) => v.toJson()).toList();
    }
    if (this.cuisineIds != null) {
      data['cuisine_ids'] = this.cuisineIds.map((v) => v.toJson()).toList();
    }
    if (this.variations != null) {
      data['variations'] = this.variations.map((v) => v.toJson()).toList();
    }
    if (this.addOns != null) {
      data['add_ons'] = this.addOns.map((v) => v.toJson()).toList();
    }
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['available_time_starts'] = this.availableTimeStarts;
    data['available_time_ends'] = this.availableTimeEnds;
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_discount'] = this.restaurantDiscount;
    data['schedule_order'] = this.scheduleOrder;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['status'] = this.status;
    data['f_featured'] = this.featured;
    data['f_trending'] = this.trending;
    data['f_isNew'] = this.isNew;
    data['veg'] = this.veg;
    return data;
  }

  Product copyWith({
    int id,
    String name,
    String description,
    String image,
    int categoryId,
    List<CategoryIds> categoryIds,
    int cuisineId,
    List<CuisineIds> cuisineIds,
    List<Variation> variations,
    List<AddOns> addOns,
    List<ChoiceOptions> choiceOptions,
    double price,
    double tax,
    double discount,
    String discountType,
    String availableTimeStarts,
    String availableTimeEnds,
    int restaurantId,
    String restaurantName,
    double restaurantDiscount,
    bool scheduleOrder,
    double avgRating,
    int ratingCount,
    int status,
    String featured,
    String trending,
    String isNew,
    int veg,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      categoryId: categoryId ?? this.categoryId,
      categoryIds: categoryIds ?? this.categoryIds,
      cuisineIds: cuisineIds ?? this.cuisineIds,
      variations: variations ?? this.variations,
      addOns: addOns ?? this.addOns,
      choiceOptions: choiceOptions ?? this.choiceOptions,
      price: price ?? this.price,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      availableTimeStarts: availableTimeStarts ?? this.availableTimeStarts,
      availableTimeEnds: availableTimeEnds ?? this.availableTimeEnds,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantDiscount: restaurantDiscount ?? this.restaurantDiscount,
      scheduleOrder: scheduleOrder ?? this.scheduleOrder,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      status: status ?? this.status,
      featured: featured ?? this.featured,
      trending: trending ?? this.trending,
      isNew: isNew ?? this.isNew,
      veg: veg ?? this.veg,
    );
  }
}

class CategoryIds {
  String id;

  CategoryIds({
    this.id,
  });

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class CuisineIds {
  String id;

  CuisineIds({
    this.id,
  });

  CuisineIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Variation {
  String type;
  double price;

  Variation({this.type, this.price});

  Variation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}

class AddOns {
  int id;
  String name;
  double price;

  AddOns({this.id, this.name, this.price});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class ChoiceOptions {
  String name;
  String title;
  List<String> options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    print('=== chooseOptions: ${json.toString()}');
    name = json['name'];
    print('=== chooseName: $name');
    title = json['title'];
    print('=== chooseName: $title');
    options = [];
    if (json['options'] != null) {
      String ops = json['options'].toString();
      ops.replaceAll('[', '').replaceAll(']', '');
      options.add(ops);
    }
    print('=== chooseName: ${options.toString()}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['options'] = this.options;
    return data;
  }
}
