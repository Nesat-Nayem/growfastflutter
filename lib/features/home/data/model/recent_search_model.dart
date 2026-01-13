class RecentSearchModel {
  final int id;
  final String? title;
  final String? image;

  RecentSearchModel({
    required this.id,
    required this.title,
    this.image,
  });

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchModel(
      id: json['id'],
      title: json['title'] ?? '',
      image: json['image'],
    );
  }
}
