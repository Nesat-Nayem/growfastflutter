import '../../domain/entities/country_entity.dart';

class CountryDto extends CountryEntity {
  const CountryDto({
    required super.id,
    required super.code,
    required super.name,
    required super.phoneCode,
  });

  factory CountryDto.fromJson(Map<String, dynamic> json) {
    return CountryDto(
      id: json['id'],
      code: json['sortname'],
      name: json['name'],
      phoneCode: json['phonecode'],
    );
  }
}
