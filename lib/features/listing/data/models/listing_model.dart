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
    return ListingModel(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      image: json['image'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      price: json['price'],
      description: json['description'],
      additionalServices: json['additional_services'],
      videoLink: json['video_link'],
      address: json['address'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      pincode: json['pincode'],
      status: json['status'],
      view: json['view'],
      trustSeal: json['trust_seal'],
      gstNumber: json['gst_number'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      gallery: (json['gallery'] as List)
          .map((e) => Gallery.fromJson(e))
          .toList(),
      user: User.fromJson(json['user']),
      includes:
          (json['includes'] as List<dynamic>?)
              ?.map((e) => Include.fromJson(e))
              .toList() ??
          [],
      faqs:
          (json['faqs'] as List<dynamic>?)
              ?.map((e) => Faq.fromJson(e))
              .toList() ??
          [],
    );
  }
}
