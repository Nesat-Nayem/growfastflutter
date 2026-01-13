class ServiceSectionModel {
  final int id;
  final String slug;
  final String title;
  final String? image;
  final String serviceType;
  final int categoryId;
  final int? subcategoryId;
  final String price;
  final String? description;
  final String? address;
  final String? country;
  final String? city;
  final String? state;
  final int status;
  final int? trustSeal;
  final String? gstNumber;
  final String? serviceImage;
  final List<ServiceGalleryModel> gallery;

  ServiceSectionModel({
    required this.id,
    required this.slug,
    required this.title,
    this.image,
    required this.serviceType,
    required this.categoryId,
    this.subcategoryId,
    required this.price,
    this.description,
    this.address,
    this.country,
    this.city,
    this.state,
    required this.status,
    this.trustSeal,
    this.gstNumber,
    this.serviceImage,
    this.gallery = const [],
  });

  factory ServiceSectionModel.fromJson(Map<String, dynamic> json) {
    List<ServiceGalleryModel> galleryList = [];
    if (json['gallery'] != null && json['gallery'] is List) {
      galleryList = (json['gallery'] as List)
          .map((e) => ServiceGalleryModel.fromJson(e))
          .toList();
    }

    return ServiceSectionModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      image: json['image'],
      serviceType: json['service_type'] ?? '',
      categoryId: json['category_id'] ?? 0,
      subcategoryId: json['subcategory_id'],
      price: json['price']?.toString() ?? '0',
      description: json['description'],
      address: json['address'],
      country: json['country'],
      city: json['city'],
      state: json['state'],
      status: json['status'] ?? 0,
      trustSeal: json['trust_seal'],
      gstNumber: json['gst_number'],
      serviceImage: json['service_image'],
      gallery: galleryList,
    );
  }
}

class ServiceGalleryModel {
  final int id;
  final String type;
  final int postId;
  final String img;
  final int userId;
  final int status;

  ServiceGalleryModel({
    required this.id,
    required this.type,
    required this.postId,
    required this.img,
    required this.userId,
    required this.status,
  });

  factory ServiceGalleryModel.fromJson(Map<String, dynamic> json) {
    return ServiceGalleryModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      postId: json['post_id'] ?? 0,
      img: json['img'] ?? '',
      userId: json['user_id'] ?? 0,
      status: json['status'] ?? 0,
    );
  }
}

enum ServiceType {
  featured('featured', 'Our Featured Services'),
  popular('popular', 'Popular Services'),
  emergency('emergency', 'Emergency Services'),
  newlyOnboarded('newly_onboarded', 'Newly Onboarded'),
  recommended('recommended', 'Recommended for You'),
  seasonal('seasonal', 'Seasonal / Festive Services');

  final String value;
  final String displayTitle;

  const ServiceType(this.value, this.displayTitle);
}
