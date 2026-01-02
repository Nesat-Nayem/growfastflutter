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
      id: json['id'] as int,
      name: json['user']['name'] as String? ?? '',
      email: json['user']['email'] as String? ?? '',
      image: json['user']['image'] as String? ?? '',
      noOfServices: json['no_of_services'] as int? ?? 0,
      overAllReview: json['overall_review'] as int? ?? 0,
      totalNoOfRatings: json['total_no_of_ratings'] as int? ?? 0,
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
