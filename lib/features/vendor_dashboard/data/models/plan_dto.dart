class PlanDto {
  final int id;
  final String name;
  final String? description;
  final double amount;
  final int duration;
  final String? durationType;
  final int? serviceLimit;
  final int? bannerLimit;
  final int status;
  final List<String> features;

  PlanDto({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    required this.duration,
    this.durationType,
    this.serviceLimit,
    this.bannerLimit,
    required this.status,
    this.features = const [],
  });

  factory PlanDto.fromJson(Map<String, dynamic> json) {
    return PlanDto(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      amount: (json['amount'] ?? 0).toDouble(),
      duration: json['duration'] ?? 12,
      durationType: json['duration_type'],
      serviceLimit: json['service_limit'],
      bannerLimit: json['banner_limit'],
      status: json['status'] ?? 0,
      features: _parseFeatures(json),
    );
  }

  static List<String> _parseFeatures(Map<String, dynamic> json) {
    final features = <String>[];
    if (json['service_limit'] != null) {
      features.add('Up to ${json['service_limit']} services');
    }
    if (json['banner_limit'] != null) {
      features.add('Up to ${json['banner_limit']} banners');
    }
    if (json['description'] != null && json['description'].toString().isNotEmpty) {
      features.addAll(json['description'].toString().split(',').map((e) => e.trim()));
    }
    return features;
  }

  bool get isFree => amount == 0;
}

class PlansResponse {
  final String status;
  final List<PlanDto> plans;
  final VendorInfo? vendor;

  PlansResponse({
    required this.status,
    required this.plans,
    this.vendor,
  });

  factory PlansResponse.fromJson(Map<String, dynamic> json) {
    return PlansResponse(
      status: json['status'] ?? '',
      plans: (json['plans'] as List?)
          ?.map((e) => PlanDto.fromJson(e))
          .toList() ?? [],
      vendor: json['vendor'] != null ? VendorInfo.fromJson(json['vendor']) : null,
    );
  }
}

class VendorInfo {
  final int id;
  final String name;
  final String email;
  final String? phone;

  VendorInfo({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    return VendorInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
    );
  }
}
