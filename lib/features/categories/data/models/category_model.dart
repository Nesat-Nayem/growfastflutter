import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required int id,
    required String name,
    required String slug,
    String? image,
    required int status,
  }) : super(
          id: id,
          name: name,
          slug: slug,
          image: image,
          status: status,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      image: json['image'] as String?,
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
