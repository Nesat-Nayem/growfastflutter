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
  final String locality;
  final String subLocality;
  final String pincode;

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
    required this.locality,
    required this.subLocality,
    required this.pincode,
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
  };
}
