import '../../domain/entities/booking_location.dart';

class BookingLocationModel extends BookingLocation {
  BookingLocationModel({
    required super.id,
    required super.name,
    required super.address,
    required super.staffCount,
    required super.country,
    required super.state,
    required super.city,
  });

  factory BookingLocationModel.fromJson(Map<String, dynamic> json) {
    return BookingLocationModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Demo Name',
      address: json['address'] as String? ?? 'Demo Address',
      staffCount: json['staff_count'] as int? ?? 0,
      country: json['country'] as int? ?? 0,
      state: json['state'] as int? ?? 0,
      city: json['city'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'staff_count': staffCount,
      'country': country,
      'state': state,
      'city': city,
    };
  }
}
