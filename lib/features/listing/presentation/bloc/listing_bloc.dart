import 'dart:developer' as developer;

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
    on<LoadMoreListings>(_onLoadMoreListings);
    on<LoadListingDetail>(_onLoadListingDetail);
  }

  Future<void> _onLoadListings(
    LoadListings event,
    Emitter<ListingState> emit,
  ) async {
    developer.log(
      '_onLoadListings -> received params: ${event.params.toQuery()}',
      name: 'ListingBloc',
    );
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        listings: [],
        totalNumberOfListings: 0,
        currentPage: 1,
        lastPage: 1,
        hasMorePages: false,
        clearError: true,
      ),
    );
    developer.log(
      '_onLoadListings -> emitted loading state',
      name: 'ListingBloc',
    );

    try {
      final result = await getListingsUseCase(event.params);

      developer.log(
        '_onLoadListings -> usecase completed',
        name: 'ListingBloc',
      );

      result.fold(
        (failure) {
          developer.log(
            '_onLoadListings -> failure: ${Helpers.convertFailureToMessage(failure)}',
            name: 'ListingBloc',
            error: failure,
          );
          emit(
            state.copyWith(
              isLoading: false,
              error: Helpers.convertFailureToMessage(failure),
            ),
          );
        },
        (response) {
          developer.log(
            '_onLoadListings -> success: listings=${response.listings.length}, total=${response.total}, page=${response.currentPage}/${response.lastPage}',
            name: 'ListingBloc',
          );
          emit(
            state.copyWith(
              isLoading: false,
              listings: response.listings,
              totalNumberOfListings: response.total,
              currentPage: response.currentPage,
              lastPage: response.lastPage,
              hasMorePages: response.hasMorePages,
              clearError: true,
            ),
          );
        },
      );
    } catch (e) {
      developer.log(
        '_onLoadListings -> exception: $e',
        name: 'ListingBloc',
        error: e,
      );
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> _onLoadMoreListings(
    LoadMoreListings event,
    Emitter<ListingState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMorePages) {
      developer.log(
        '_onLoadMoreListings -> skipping: isLoadingMore=${state.isLoadingMore}, hasMorePages=${state.hasMorePages}',
        name: 'ListingBloc',
      );
      return;
    }

    developer.log(
      '_onLoadMoreListings -> loading page ${state.currentPage + 1}',
      name: 'ListingBloc',
    );

    emit(state.copyWith(isLoadingMore: true));

    try {
      final params = event.params.copyWith(page: state.currentPage + 1);
      final result = await getListingsUseCase(params);

      result.fold(
        (failure) {
          developer.log(
            '_onLoadMoreListings -> failure: ${Helpers.convertFailureToMessage(failure)}',
            name: 'ListingBloc',
          );
          emit(state.copyWith(isLoadingMore: false));
        },
        (response) {
          developer.log(
            '_onLoadMoreListings -> success: newListings=${response.listings.length}, page=${response.currentPage}/${response.lastPage}',
            name: 'ListingBloc',
          );
          emit(
            state.copyWith(
              isLoadingMore: false,
              listings: [...state.listings, ...response.listings],
              currentPage: response.currentPage,
              lastPage: response.lastPage,
              hasMorePages: response.hasMorePages,
            ),
          );
        },
      );
    } catch (e) {
      developer.log(
        '_onLoadMoreListings -> exception: $e',
        name: 'ListingBloc',
        error: e,
      );
      emit(state.copyWith(isLoadingMore: false));
    }
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
