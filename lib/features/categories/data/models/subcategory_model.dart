import '../../domain/entities/subcategory.dart';

class SubcategoryModel extends Subcategory {
  const SubcategoryModel({
    required int id,
    required int categoryId,
    required String title,
    String? image,
    required int status,
  }) : super(
          id: id,
          categoryId: categoryId,
          title: title,
          image: image,
          status: status,
        );

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      title: json['title'] as String,
      image: json['image'] as String?,
      status: json['status'] as int,
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
