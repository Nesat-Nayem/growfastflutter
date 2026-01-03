import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/domain/entities/user.dart';

class ListingModel extends Listing {
  const ListingModel({
    required super.id,
    required super.slug,
    required super.title,
    super.image,
    required super.userId,
    required super.categoryId,
    required super.subcategoryId,
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
    required super.user,
    required super.includes,
    required super.faqs,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final galleryList = (json['gallery'] as List?) ?? [];
    final includesList = (json['includes'] as List?) ?? [];
    final faqsList = (json['faqs'] as List?) ?? [];
    int parseInt(dynamic value) =>
        value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
    DateTime parseDate(dynamic value) =>
        DateTime.tryParse(value?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);

    return ListingModel(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      image: json['image'],
      userId: json['user_id'],
      categoryId: json['category_id'],
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
      status: parseInt(json['status']),
      view: parseInt(json['view']),
      trustSeal: parseInt(json['trust_seal']),
      gstNumber: json['gst_number'],
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      gallery: galleryList.map((e) => Gallery.fromJson(e)).toList(),
      user: User.fromJson(json['user']),
      includes: includesList.map((e) => Include.fromJson(e)).toList(),
      faqs: faqsList.map((e) => Faq.fromJson(e)).toList(),
    );
  }
}
