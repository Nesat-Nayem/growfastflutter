import '../../domain/entities/booking_location.dart';

class BookingLocationModel extends BookingLocation {
  BookingLocationModel({
    required super.id,
    required super.name,
    required super.address,
    required super.staffCount,
    required super.country,
    required super.state,
    required super.city,
    super.serviceImage,
    super.serviceTitle,
    super.serviceRating,
  });

  factory BookingLocationModel.fromJson(Map<String, dynamic> json) {
    final countryName = json['country_name']?.toString();
    final stateName = json['state_name']?.toString();
    final cityName = json['city_name']?.toString();
    
    String locationName = '';
    if (cityName != null && cityName.isNotEmpty) {
      locationName = cityName;
    } else if (stateName != null && stateName.isNotEmpty) {
      locationName = stateName;
    } else if (countryName != null && countryName.isNotEmpty) {
      locationName = countryName;
    } else {
      locationName = 'Location Not Available';
    }
    
    String locationAddress = '';
    if (cityName != null && stateName != null && countryName != null) {
      locationAddress = '$cityName, $stateName, $countryName';
    } else if (json['post_code']?.toString() != null) {
      locationAddress = 'Postal Code: ${json['post_code']}';
    } else {
      locationAddress = 'Address Not Available';
    }
    
    return BookingLocationModel(
      id: int.tryParse(json['country_id']?.toString() ?? json['city_id']?.toString() ?? '0') ?? 0,
      name: locationName,
      address: locationAddress,
      staffCount: int.tryParse(json['staff_count']?.toString() ?? '0') ?? 0,
      country: int.tryParse(json['country_id']?.toString() ?? '0') ?? 0,
      state: int.tryParse(json['state_id']?.toString() ?? '0') ?? 0,
      city: int.tryParse(json['city_id']?.toString() ?? '0') ?? 0,
      serviceImage: json['service_image']?.toString(),
      serviceTitle: json['service_title']?.toString(),
      serviceRating: double.tryParse(json['service_rating']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'staff_count': staffCount,
      'country': country,
      'state': state,
      'city': city,
      'service_image': serviceImage,
      'service_title': serviceTitle,
      'service_rating': serviceRating,
    };
  }
}
