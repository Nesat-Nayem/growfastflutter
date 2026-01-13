import 'package:equatable/equatable.dart';
import 'package:grow_first/features/listing/domain/entities/user.dart';
import 'package:grow_first/features/reviews/domain/entities.dart/review.dart';

class Listing extends Equatable {
  final int id;
  final String slug;
  final String title;
  final String? image;
  final int userId;
  final int categoryId;
  final int subcategoryId;
  final String price;
  final String description;
  final String? additionalServices;
  final String? videoLink;
  final String address;
  final String country;
  final String state;
  final String city;
  final String pincode;
  final int status;
  final int view;
  final int trustSeal;
  final String? gstNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Gallery> gallery;
  final User user;
  final List<Include> includes;
  final List<Faq> faqs;
final List<Review> reviews;
final double overAllRating;
final int totalRatings;
final String? website;

  const Listing({
    required this.id,
    required this.slug,
    required this.title,
    this.image,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
    required this.price,
    required this.description,
    this.additionalServices,
    this.videoLink,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.pincode,
    required this.status,
    required this.view,
    required this.trustSeal,
    this.gstNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.gallery,
    required this.user,
    required this.includes,
    required this.faqs,
    required this.reviews,
    required this.overAllRating,
    required this.totalRatings,
    required this.website,
  });

  @override
  List<Object?> get props => [id];
}

class Gallery {
  final int id;
  final String type;
  final int postId;
  final String img;
  final int userId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Gallery({
    required this.id,
    required this.type,
    required this.postId,
    required this.img,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'],
      type: json['type'],
      postId: json['post_id'],
      img: json['img'],
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Include {
  final int id;
  final int serviceId;
  final String title;
  final String? description;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Include({
    required this.id,
    required this.serviceId,
    required this.title,
    this.description,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Include.fromJson(Map<String, dynamic> json) => Include(
    id: json['id'],
    serviceId: json['service_id'],
    title: json['title'],
    description: json['description'],
    image: json['image'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'service_id': serviceId,
    'title': title,
    'description': description,
    'image': image,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

class Faq {
  final int id;
  final int serviceId;
  final String question;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Faq({
    required this.id,
    required this.serviceId,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    id: json['id'],
    serviceId: json['service_id'],
    question: json['question'],
    answer: json['answer'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'service_id': serviceId,
    'question': question,
    'answer': answer,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
