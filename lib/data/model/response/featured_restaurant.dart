class FeaturedRestaurant {
  int id;
  int venueId;
  String title;
  String description;
  String venueName;
  String featuredImage;
  int status;

  FeaturedRestaurant({
    this.id,
    this.venueId,
    this.title,
    this.description,
    this.venueName,
    this.featuredImage,
    this.status,
  });

  FeaturedRestaurant copyWith({
    int id,
    int venueId,
    String title,
    String description,
    String venueName,
    String featuredImage,
    int status,
  }) {
    return FeaturedRestaurant(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      title: title ?? this.title,
      description: description ?? this.description,
      venueName: venueName ?? this.venueName,
      featuredImage: featuredImage ?? this.featuredImage,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'venue_id': this.venueId,
      'title': this.title,
      'description': this.description,
      'venue_name': this.venueName,
      'featured_image': this.featuredImage,
      'status': this.status,
    };
  }

  factory FeaturedRestaurant.fromJson(Map<String, dynamic> map) {
    return FeaturedRestaurant(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      venueId: map['venue_id'] ?? 0,
      description: map['description'] ?? '',
      venueName: map['venue_name'] ?? '',
      featuredImage: map['featured_image'] ?? 'def.png',
      status: map['status'] ?? 0,
    );
  }
}
