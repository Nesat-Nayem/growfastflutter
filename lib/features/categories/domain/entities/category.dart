// domain/entities/category.dart
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String slug;
  final String name;
  final String image;

  const Category({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
  });

  @override
  List<Object> get props => [id, name];
}
