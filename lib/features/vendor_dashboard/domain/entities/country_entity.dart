import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final int phoneCode;

  const CountryEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.phoneCode,
  });

  @override
  List<Object?> get props => [id];
}
