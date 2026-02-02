import 'dart:io';

class KycUploadRequest {
  final File? aadhar;
  final File? pan;
  final File? passport;
  final String? idCard;

  KycUploadRequest({
    this.aadhar,
    this.pan,
    this.passport,
    this.idCard,
  });
}

class KycUploadResponse {
  final String status;
  final String message;

  KycUploadResponse({
    required this.status,
    required this.message,
  });

  factory KycUploadResponse.fromJson(Map<String, dynamic> json) {
    return KycUploadResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
