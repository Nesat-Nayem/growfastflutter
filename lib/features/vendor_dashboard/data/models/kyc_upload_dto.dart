import 'dart:io';

class KycUploadRequest {
  final File? aadhar;
  final File? pan;

  KycUploadRequest({
    this.aadhar,
    this.pan,
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
