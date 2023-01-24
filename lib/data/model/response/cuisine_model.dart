class CuisineModel {
  int _id;
  String _name;
  String _image;
  int _activeStatus;
  int _status;
  String _createdAt;
  String _updatedAt;

  CuisineModel({
    int id,
    String name,
    String image,
    int activeStatus,
    int status,
    String createdAt,
    String updatedAt,
  }) {
    this._id = id;
    this._name = name;
    this._image = image;
    this._activeStatus = activeStatus;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  String get name => _name;
  String get image => _image;
  int get activeStatus => _activeStatus;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  CuisineModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _activeStatus = json['active_status'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['active_status'] = this._activeStatus;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['image'] = this._image;
    return data;
  }
}
