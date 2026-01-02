import 'package:equatable/equatable.dart';

class CountryParams extends Equatable {
  final String? name;
  final int? page;

  const CountryParams({this.name, this.page});

  @override
  List<Object?> get props => [name, page];
}
