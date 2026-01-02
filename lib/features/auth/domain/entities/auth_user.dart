import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final int id;
  final String refCode;
  final String? refBy;
  final String name;
  final String? userName;
  final String? gender;
  final String? dateOfBirth;
  final String? country;
  final String? state;
  final String? city;
  final String? postCode;
  final String email;
  final String phone;
  final String? address;
  final String? subLocality;
  final String? image;
  final int balance;
  final String? companyName;
  final String? companyAddress;
  final String? gstin;
  final String? adhar;
  final String? pan;
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
  final String otp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? twitterUrl;
  final String? whatsappNumber;
  final String? youtubeUrl;
  final String? linkedinUrl;
  final int? serviceId;

  const AuthUser({
    required this.id,
    required this.refCode,
    this.refBy,
    required this.name,
    this.userName,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.state,
    this.city,
    this.postCode,
    required this.email,
    required this.phone,
    this.address,
    this.subLocality,
    this.image,
    required this.balance,
    this.companyName,
    this.companyAddress,
    this.gstin,
    this.adhar,
    this.pan,
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
    required this.otp,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.whatsappNumber,
    this.youtubeUrl,
    this.linkedinUrl,
    this.serviceId,
  });

  @override
  List<Object?> get props => [id];
}
