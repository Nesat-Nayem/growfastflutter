import 'package:grow_first/features/auth/domain/entities/country.dart';

class CountryModel extends Country {
  CountryModel({
    required super.name,
    required super.flag,
    required super.code,
    required super.dialCode,
    required super.nameTranslations,
    required super.minLength,
    required super.maxLength,
  });
}
