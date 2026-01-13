import 'dart:convert';

class HomeServiceModel {
  final int id;
  final String name;
  final String image;
  final int serviceCount;
  final String? latestServiceImage;

  HomeServiceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.serviceCount,
    required this.latestServiceImage,
  });

  factory HomeServiceModel.fromJson(Map<String, dynamic> json) {
    return HomeServiceModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      serviceCount: json['services_count'],
      latestServiceImage: json['latest_service_image'],
    );
  }
}
