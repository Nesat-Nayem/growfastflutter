class PlanDto {
  final int id;
  final String name;
  final String? description;
  final double amount;
  final int duration;
  final String? durationType;
  final int? serviceLimit;
  final int? bannerLimit;
  final bool isPremium;
  final dynamic status;
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
    this.isPremium = false,
    required this.status,
    this.features = const [],
  });

  factory PlanDto.fromJson(Map<String, dynamic> json) {
    return PlanDto(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: _parseDescription(json['description']),
      amount: _parseAmount(json['amount']),
      duration: json['duration'] ?? 12,
      durationType: json['duration_type'],
      serviceLimit: json['service_limit'],
      bannerLimit: json['banner_limit'],
      isPremium: json['is_premium'] == 1 || json['is_premium'] == true,
      status: json['status'],
      features: _parseFeatures(json),
    );
  }

  static double _parseAmount(dynamic amount) {
    if (amount == null) return 0.0;
    if (amount is double) return amount;
    if (amount is int) return amount.toDouble();
    if (amount is String) return double.tryParse(amount) ?? 0.0;
    return 0.0;
  }

  /// Parse description and strip HTML tags
  static String? _parseDescription(dynamic description) {
    if (description == null) return null;
    final desc = description.toString()
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
    return desc.isEmpty ? null : desc;
  }

  static List<String> _parseFeatures(Map<String, dynamic> json) {
    final features = <String>[];
    if (json['service_limit'] != null) {
      features.add('Up to ${json['service_limit']} services');
    }
    if (json['banner_limit'] != null) {
      final limit = json['banner_limit'];
      features.add(limit == 0 ? 'Unlimited banners' : 'Up to $limit banners');
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
