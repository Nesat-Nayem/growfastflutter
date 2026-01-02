import 'package:equatable/equatable.dart';

class Subcategory extends Equatable {
  final int id;
  final int categoryId;
  final String title;
  final String image;
  final int status;

  const Subcategory({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.image,
    required this.status,
  });

  @override
  List<Object?> get props => [id, categoryId, title, image, status];
}
