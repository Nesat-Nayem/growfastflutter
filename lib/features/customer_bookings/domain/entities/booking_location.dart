class BookingLocation {
  final int id;
  final String name;
  final String address;
  final int staffCount;
  final int country;
  final int state;
  final int city;
  final String? serviceImage;
  final String? serviceTitle;
  final double? serviceRating;

  BookingLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.staffCount,
    required this.country,
    required this.state,
    required this.city,
    this.serviceImage,
    this.serviceTitle,
    this.serviceRating,
  });
}
