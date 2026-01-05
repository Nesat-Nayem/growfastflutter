class CartModel {
  final int id;
  final int userId;
  final int staffId;
  final int serviceId;
  final double servicePrice;
  final double totalPrice;
  final String bookingDate;
  final String? bookingSlots;
  final String? bookingNote;
  final String? staffName;
  final String? staffEmail;
  final ServiceInfo? service;
  final List<CartItemModel> cartItems;
  final CartAddress? address;

  CartModel({
    required this.id,
    required this.userId,
    required this.staffId,
    required this.serviceId,
    required this.servicePrice,
    required this.totalPrice,
    required this.bookingDate,
    this.bookingSlots,
    this.bookingNote,
    this.staffName,
    this.staffEmail,
    this.service,
    this.cartItems = const [],
    this.address,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      staffId: int.tryParse(json['staff_id']?.toString() ?? '0') ?? 0,
      serviceId: int.tryParse(json['service_id']?.toString() ?? '0') ?? 0,
      servicePrice: double.tryParse(json['service_price']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      bookingDate: json['booking_date']?.toString() ?? '',
      bookingSlots: json['booking_slots']?.toString(),
      bookingNote: json['booking_note']?.toString(),
      staffName: json['staff_name']?.toString(),
      staffEmail: json['staff_email']?.toString(),
      service: json['service'] != null ? ServiceInfo.fromJson(json['service']) : null,
      cartItems: json['cart_items'] != null
          ? (json['cart_items'] as List).map((e) => CartItemModel.fromJson(e)).toList()
          : [],
      address: json['cart_adresses'] != null && (json['cart_adresses'] as List).isNotEmpty
          ? CartAddress.fromJson((json['cart_adresses'] as List).first)
          : null,
    );
  }
}

class CartItemModel {
  final int id;
  final int cartId;
  final int additionalServicesId;
  final double price;
  final AdditionalServiceInfo? additionalService;

  CartItemModel({
    required this.id,
    required this.cartId,
    required this.additionalServicesId,
    required this.price,
    this.additionalService,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      cartId: int.tryParse(json['cart_id']?.toString() ?? '0') ?? 0,
      additionalServicesId: int.tryParse(json['additional_services_id']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      additionalService: json['additional_services'] != null
          ? AdditionalServiceInfo.fromJson(json['additional_services'])
          : null,
    );
  }
}

class ServiceInfo {
  final int id;
  final String title;
  final String? image;
  final double price;

  ServiceInfo({
    required this.id,
    required this.title,
    this.image,
    required this.price,
  });

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      image: json['service_image']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class AdditionalServiceInfo {
  final int id;
  final String name;
  final double price;

  AdditionalServiceInfo({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AdditionalServiceInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalServiceInfo(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class CartAddress {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String zipCode;

  CartAddress({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.zipCode,
  });

  factory CartAddress.fromJson(Map<String, dynamic> json) {
    return CartAddress(
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      zipCode: json['zip_code']?.toString() ?? '',
    );
  }
}
