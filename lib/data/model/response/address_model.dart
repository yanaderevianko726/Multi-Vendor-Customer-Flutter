class AddressModel {
  int id;
  String addressType;
  String contactPersonNumber;
  String companyName;
  String address;
  String latitude;
  String longitude;
  int zoneId;
  List<int> zoneIds;
  String method;
  String contactPersonName;
  String road;
  String villageName;
  String aptNumber;
  String house;
  String floor;

  AddressModel({
    this.id,
    this.addressType,
    this.contactPersonNumber,
    this.companyName,
    this.address,
    this.latitude,
    this.longitude,
    this.zoneId,
    this.zoneIds,
    this.method,
    this.contactPersonName,
    this.road,
    this.villageName,
    this.aptNumber,
    this.house,
    this.floor,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    companyName = json['company_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    zoneIds = json['zone_ids'] != null ? json['zone_ids'].cast<int>() : null;
    method = json['_method'];
    house = json['house'];
    road = json['road'];
    villageName = json['village_name'];
    aptNumber = json['apt_number'];
    floor = json['floor'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_type'] = this.addressType;
    data['contact_person_name'] = this.contactPersonName;
    data['contact_person_number'] = this.contactPersonNumber;
    data['company_name'] = this.companyName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zone_id'] = this.zoneId;
    data['zone_ids'] = this.zoneIds;
    data['_method'] = this.method;
    data['house'] = this.house;
    data['road'] = this.road;
    data['village_name'] = this.villageName;
    data['apt_number'] = this.aptNumber;
    data['floor'] = this.floor;
    data['address'] = this.address;
    return data;
  }
}
