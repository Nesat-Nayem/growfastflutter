// domain/entities/category.dart
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String slug;
  final String name;
  final String? image;
  final int status;

  const Category({
    required this.id,
    required this.slug,
    required this.name,
    this.image,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, image, status];
}
