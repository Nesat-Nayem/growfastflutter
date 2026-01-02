import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int id;
  final String name;
  final int stateId;

  const CityEntity({
    required this.id,
    required this.name,
    required this.stateId,
  });

  @override
  List<Object?> get props => [id];
}
