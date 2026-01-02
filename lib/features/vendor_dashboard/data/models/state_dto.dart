import '../../domain/entities/state_entity.dart';

class StateDto extends StateEntity {
  const StateDto({
    required super.id,
    required super.name,
    required super.countryId,
  });

  factory StateDto.fromJson(Map<String, dynamic> json) {
    return StateDto(
      id: json['id'],
      name: json['name'],
      countryId: json['country_id'],
    );
  }
}
