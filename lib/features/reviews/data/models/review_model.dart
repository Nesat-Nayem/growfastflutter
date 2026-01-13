

import 'package:grow_first/features/reviews/domain/entities.dart/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.userName,
    required super.userImage,
    required super.rating,
    required super.description,
    required super.time,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['user_name'] ?? 'Unknown User',
      userImage: json['user_image'] ??
          'https://growfirst.org/assets/img/default.png',
      rating: json['rating']?.toString() ?? '0',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
