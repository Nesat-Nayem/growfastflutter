import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  final int id;
  final String slug;
  final String name;
  final String image;
  final int status;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.status,
  }) : super(id: 0, slug: '', name: '', image: '');

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      image: json['image'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'status': status,
    };
  }
}
