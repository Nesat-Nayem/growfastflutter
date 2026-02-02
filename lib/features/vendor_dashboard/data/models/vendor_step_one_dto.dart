class VendorStep1Request {
  final String fullName;
  final String companyName;
  final String email;
  final String phone;
  final String gender;
  final String? website;
  final String? gst;
  final String country;
  final String state;
  final String city;
  final String? locality;
  final String? subLocality;
  final String? pincode;
  final String detailAddress;
  final String nameOfService;

  VendorStep1Request({
    required this.fullName,
    required this.companyName,
    required this.email,
    required this.phone,
    required this.gender,
    this.website,
    this.gst,
    required this.country,
    required this.state,
    required this.city,
    this.locality,
    this.subLocality,
    this.pincode,
    required this.detailAddress,
    required this.nameOfService,
  });

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "company_name": companyName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "website": website,
    "gst": gst,
    "country": country,
    "state": state,
    "city": city,
    "locality": locality,
    "sub_locality": subLocality,
    "pincode": pincode,
    "detail_address": detailAddress,
    "name_of_service": nameOfService,
  };
}

class VendorStep1Response {
  final String status;
  final String message;
  final String token;
  final String? nationality;
  final VendorData vendor;

  VendorStep1Response({
    required this.status,
    required this.message,
    required this.token,
    this.nationality,
    required this.vendor,
  });

  factory VendorStep1Response.fromJson(Map<String, dynamic> json) {
    return VendorStep1Response(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      nationality: json['nationality'],
      vendor: VendorData.fromJson(json['vendor'] ?? {}),
    );
  }
}

class VendorData {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? companyName;
  final String? role;
  final int status;

  VendorData({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.companyName,
    this.role,
    required this.status,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    return VendorData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      companyName: json['company_name'],
      role: json['role'],
      status: json['status'] ?? 0,
    );
  }
}
