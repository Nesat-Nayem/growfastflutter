part of 'listing_bloc.dart';

abstract class ListingEvent extends Equatable {
  const ListingEvent();

  @override
  List<Object?> get props => [];
}

class LoadListings extends ListingEvent {
  final GetListingsParams params;

  const LoadListings(this.params);

  @override
  List<Object?> get props => [params];
}

class LoadMoreListings extends ListingEvent {
  final GetListingsParams params;

  const LoadMoreListings(this.params);

  @override
  List<Object?> get props => [params];
}

class LoadListingDetail extends ListingEvent {
  final String id;

  const LoadListingDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadAboutUsBanners extends ListingEvent {
  const LoadAboutUsBanners();
}
