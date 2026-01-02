import 'package:equatable/equatable.dart';

class StateEntity extends Equatable {
  final int id;
  final String name;
  final int countryId;

  const StateEntity({
    required this.id,
    required this.name,
    required this.countryId,
  });

  @override
  List<Object?> get props => [id];
}
