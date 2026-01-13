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
  final int? perPage;
  final String? serviceType;

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
    this.perPage,
    this.serviceType,
  });

  Map<String, dynamic> toQuery() {
    final Map<String, dynamic> query = {};

    // Format categories as categories[]=1&categories[]=2
    if (categories != null && categories!.isNotEmpty) {
      query['categories[]'] = categories;
    }
    
    // Format ratings as ratings[]=4&ratings[]=5
    if (ratings != null && ratings!.isNotEmpty) {
      query['ratings[]'] = ratings;
    }
    
    if (keyword != null && keyword!.isNotEmpty) {
      query['keyword'] = keyword;
    }
    if (location != null && location!.isNotEmpty) {
      query['location'] = location;
    }
    if (minPrice != null) query['min_price'] = minPrice;
    if (maxPrice != null) query['max_price'] = maxPrice;
    if (sort != null && sort!.isNotEmpty) query['sort'] = sort;
    if (subcategory != null) query['subcategory'] = subcategory;
    if (page != null) query['page'] = page;
    if (perPage != null) query['per_page'] = perPage;
    if (serviceType != null && serviceType!.isNotEmpty) {
      query['service_type'] = serviceType;
    }

    return query;
  }

  GetListingsParams copyWith({
    List<int>? categories,
    String? keyword,
    String? location,
    int? minPrice,
    int? maxPrice,
    String? sort,
    List<int>? ratings,
    int? subcategory,
    int? page,
    int? perPage,
    String? serviceType,
  }) {
    return GetListingsParams(
      categories: categories ?? this.categories,
      keyword: keyword ?? this.keyword,
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sort: sort ?? this.sort,
      ratings: ratings ?? this.ratings,
      subcategory: subcategory ?? this.subcategory,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      serviceType: serviceType ?? this.serviceType,
    );
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
    perPage,
    serviceType,
  ];
}
