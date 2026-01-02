import '../../domain/entities/booking_service_detail.dart';

class BookingServiceDetailModel extends BookingServiceDetail {
  BookingServiceDetailModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.duration,
    required super.durationUnit,
  });

  factory BookingServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceDetailModel(
      id: json['id'] as int,
      title: json['name'] as String? ?? '',
      description: json['details'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      duration: json['duration_value'] as int? ?? 0,
      durationUnit: json['duration_unit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'duration_unit': durationUnit,
    };
  }
}
