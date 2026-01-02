import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/utils/helpers.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/domain/usecases/get_listing_detail_usecase.dart';
import 'package:grow_first/features/listing/domain/usecases/get_listings_usecase.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';

part 'listing_bloc_event.dart';
part 'listing_bloc_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final GetListingsUseCase getListingsUseCase;
  final GetListingDetailUseCase getListingDetailUseCase;

  ListingBloc(this.getListingsUseCase, this.getListingDetailUseCase)
    : super(const ListingState()) {
    on<LoadListings>(_onLoadListings);
    on<LoadListingDetail>(_onLoadListingDetail);
  }

  Future<void> _onLoadListings(
    LoadListings event,
    Emitter<ListingState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        listings: [],
        totalNumberOfListings: 0,
      ),
    );

    final result = await getListingsUseCase(event.params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (listings) => emit(
        state.copyWith(
          isLoading: false,
          listings: listings.listings,
          totalNumberOfListings: listings.total,
        ),
      ),
    );
  }

  Future<void> _onLoadListingDetail(
    LoadListingDetail event,
    Emitter<ListingState> emit,
  ) async {
    emit(
      state.copyWith(
        isSelectedListingLoading: true,
        error: null,
        selectedListing: null,
      ),
    );

    final result = await getListingDetailUseCase(event.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSelectedListingLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (listing) => emit(
        state.copyWith(
          isSelectedListingLoading: false,
          selectedListing: listing,
        ),
      ),
    );
  }
}
