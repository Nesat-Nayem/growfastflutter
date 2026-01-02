import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String refCode;
  final String? refBy;
  final String name;
  final String? userName;
  final String gender;
  final String? dateOfBirth;
  final String country;
  final String state;
  final String city;
  final String postCode;
  final String email;
  final String phone;
  final String address;
  final String subLocality;
  final String? image;
  final int balance;
  final String companyName;
  final String? companyAddress;
  final String? gstin;
  final String? adhar;
  final String pan;
  final String? domain;
  final String? codeId;
  final String? teamType;
  final String? jobTitle;
  final int? customerTypeId;
  final String isBlock;
  final String role;
  final int status;
  final String otpCreatedAt;
  final int step;
  final String? description;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? twitterUrl;
  final String? whatsappNumber;
  final String? youtubeUrl;
  final String? linkedinUrl;
  final int? serviceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.refCode,
    this.refBy,
    required this.name,
    this.userName,
    required this.gender,
    this.dateOfBirth,
    required this.country,
    required this.state,
    required this.city,
    required this.postCode,
    required this.email,
    required this.phone,
    required this.address,
    required this.subLocality,
    this.image,
    required this.balance,
    required this.companyName,
    this.companyAddress,
    this.gstin,
    this.adhar,
    required this.pan,
    this.domain,
    this.codeId,
    this.teamType,
    this.jobTitle,
    this.customerTypeId,
    required this.isBlock,
    required this.role,
    required this.status,
    required this.otpCreatedAt,
    required this.step,
    this.description,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.whatsappNumber,
    this.youtubeUrl,
    this.linkedinUrl,
    this.serviceId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ref_code': refCode,
      'ref_by': refBy,
      'name': name,
      'user_name': userName,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'country': country,
      'state': state,
      'city': city,
      'post_code': postCode,
      'email': email,
      'phone': phone,
      'address': address,
      'sub_locality': subLocality,
      'image': image,
      'balance': balance,
      'company_name': companyName,
      'company_address': companyAddress,
      'gstin': gstin,
      'adhar': adhar,
      'pan': pan,
      'domain': domain,
      'codeid': codeId,
      'team_type': teamType,
      'job_title': jobTitle,
      'customer_type_id': customerTypeId,
      'is_block': isBlock,
      'role': role,
      'status': status,
      'otp_created_at': otpCreatedAt,
      'step': step,
      'description': description,
      'facebook_url': facebookUrl,
      'instagram_url': instagramUrl,
      'twitter_url': twitterUrl,
      'whatsapp_number': whatsappNumber,
      'youtube_url': youtubeUrl,
      'linkedin_url': linkedinUrl,
      'service_id': serviceId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      refCode: json['ref_code'] ?? '',
      refBy: json['ref_by'],
      name: json['name'] ?? '',
      userName: json['user_name'],
      gender: json['gender'] ?? '',
      dateOfBirth: json['date_of_birth'],
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      postCode: json['post_code']?.toString() ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address'] ?? '',
      subLocality: json['sub_locality'] ?? '',
      image: json['image'],
      balance: json['balance'] ?? 0,
      companyName: json['company_name'] ?? '',
      companyAddress: json['company_address'],
      gstin: json['gstin'],
      adhar: json['adhar'],
      pan: json['pan'] ?? '',
      domain: json['domain'],
      codeId: json['codeid'],
      teamType: json['team_type'],
      jobTitle: json['job_title'],
      customerTypeId: json['customer_type_id'],
      isBlock: json['is_block'] ?? 'N',
      role: json['role'] ?? '',
      status: json['status'] ?? 0,
      otpCreatedAt: json['otp_created_at'] ?? '',
      step: json['step'] ?? 0,
      description: json['description'],
      facebookUrl: json['facebook_url'],
      instagramUrl: json['instagram_url'],
      twitterUrl: json['twitter_url'],
      whatsappNumber: json['whatsapp_number'],
      youtubeUrl: json['youtube_url'],
      linkedinUrl: json['linkedin_url'],
      serviceId: json['service_id'],
      createdAt:
          DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updated_at'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
