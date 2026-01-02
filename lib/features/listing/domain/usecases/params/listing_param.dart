import 'package:equatable/equatable.dart';

class GetListingsParams extends Equatable {
  final List<int>? categories;
  final String? keyword;
  final String? location;
  final int? minPrice;
  final int? maxPrice;
  final String? sort;
  final List<int>? ratings;
  final int? subcategory;
  final int? page;

  const GetListingsParams({
    this.categories,
    this.keyword,
    this.location,
    this.minPrice,
    this.maxPrice,
    this.sort,
    this.ratings,
    this.subcategory,
    this.page,
  });

  Map<String, dynamic> toQuery() {
    final Map<String, dynamic> query = {};

    if (categories != null) query['categories'] = categories;
    if (ratings != null) query['ratings[]'] = ratings;
    if (keyword != null) query['keyword'] = keyword;
    if (location != null) query['location'] = location;
    if (minPrice != null) query['min_price'] = minPrice;
    if (maxPrice != null) query['max_price'] = maxPrice;
    if (sort != null) query['sort'] = sort;
    if (subcategory != null) query['subcategory'] = subcategory;
    if (page != null) query['page'] = page;

    return query;
  }

  @override
  List<Object?> get props => [
    categories,
    keyword,
    location,
    minPrice,
    maxPrice,
    sort,
    ratings,
    subcategory,
    page,
  ];
}
