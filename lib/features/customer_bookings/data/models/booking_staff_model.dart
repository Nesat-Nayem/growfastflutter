import '../../domain/entities/booking_staff.dart';

class BookingStaffModel extends BookingStaff {
  BookingStaffModel({
    required super.id,
    required super.name,
    required super.email,
    required super.image,
    required super.noOfServices,
    required super.overAllReview,
    required super.totalNoOfRatings,
  });

  factory BookingStaffModel.fromJson(Map<String, dynamic> json) {
    return BookingStaffModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['user']?['name']?.toString() ?? '',
      email: json['user']?['email']?.toString() ?? '',
      image: json['user']?['image']?.toString() ?? '',
      noOfServices: int.tryParse(json['no_of_services']?.toString() ?? '0') ?? 0,
      overAllReview:
          int.tryParse(json['overall_review']?.toString() ?? '0') ?? 0,
      totalNoOfRatings:
          int.tryParse(json['total_no_of_ratings']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'noOfServices': noOfServices,
    };
  }
}
