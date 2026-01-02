import '../../domain/entities/subcategory.dart';

class SubcategoryModel extends Subcategory {
  const SubcategoryModel({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.image,
    required super.status,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'image': image,
      'status': status,
    };
  }
}
