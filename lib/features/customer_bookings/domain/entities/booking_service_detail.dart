class BookingServiceDetail {
  final int id;
  final String title;
  final String description;
  final double price;
  final int duration;
  final String durationUnit;
  final String? image;

  BookingServiceDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.durationUnit,
    this.image,
  });
}
