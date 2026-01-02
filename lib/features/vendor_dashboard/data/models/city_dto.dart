import '../../domain/entities/city_entity.dart';

class CityDto extends CityEntity {
  const CityDto({
    required super.id,
    required super.name,
    required super.stateId,
  });

  factory CityDto.fromJson(Map<String, dynamic> json) {
    return CityDto(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }
}
