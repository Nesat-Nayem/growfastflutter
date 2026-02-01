import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/domain/entities/user.dart';
import 'package:grow_first/features/reviews/data/models/review_model.dart';

class ListingModel extends Listing {
  const ListingModel({
    required super.id,
    required super.slug,
    required super.title,
    super.image,
    required super.userId,
    required super.categoryId,
    super.subcategoryId,
    required super.price,
    required super.description,
    super.additionalServices,
    super.videoLink,
    required super.address,
    required super.country,
    required super.state,
    required super.city,
    required super.pincode,
    required super.status,
    required super.view,
    required super.trustSeal,
    super.gstNumber,
    required super.createdAt,
    required super.updatedAt,
    required super.gallery,
    super.user,
    required super.includes,
    required super.faqs,
    required super.reviews,
    required super.overAllRating,
    required super.totalRatings,
    super.website,
    super.reviewsBreakdown,
    super.latitude,
    super.longitude,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json['reviews'] is List
        ? json['reviews'] as List
        : const [];

    return ListingModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      image: json['image'],
      userId: json['user_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subcategoryId: json['subcategory_id'],
      price: json['price']?.toString() ?? '0',
      description: json['description'] ?? '',
      additionalServices: json['additional_services'],
      videoLink: json['video_link'],
      address: json['address'] ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      view: int.tryParse(json['view']?.toString() ?? '0') ?? 0,
      trustSeal: int.tryParse(json['trust_seal']?.toString() ?? '0') ?? 0,
      gstNumber: json['gst_number'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      gallery: (json['gallery'] as List? ?? [])
          .map((e) => Gallery.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
      includes: (json['includes'] as List? ?? [])
          .map((e) => Include.fromJson(e as Map<String, dynamic>))
          .toList(),
      faqs: (json['faqs'] as List? ?? []).map((e) => Faq.fromJson(e as Map<String, dynamic>)).toList(),
      reviews: reviewsJson.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>)).toList(),
      overAllRating:
          double.tryParse(json['over_all_rating']?.toString() ?? '0') ?? 0,
      totalRatings: int.tryParse(json['total_ratings']?.toString() ?? '0') ?? 0,
      website: json['website_url'],
      reviewsBreakdown: json['reviews_breakdown'] != null
          ? ReviewsBreakdown.fromJson(json['reviews_breakdown'] as Map<String, dynamic>)
          : null,
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
    );
  }
}
