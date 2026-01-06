import '../../domain/entities/booking_service_detail.dart';

class BookingServiceDetailModel extends BookingServiceDetail {
  BookingServiceDetailModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.duration,
    required super.durationUnit,
    super.image,
  });

  factory BookingServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['name']?.toString() ?? '',
      description: json['details']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      duration: int.tryParse(json['duration_value']?.toString() ?? '0') ?? 0,
      durationUnit: json['duration_unit']?.toString() ?? '',
      image: json['image']?.toString(),
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
      'image': image,
    };
  }
}
