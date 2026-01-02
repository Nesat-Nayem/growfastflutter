import 'package:dio/dio.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_bloc.dart';

import '../data/remote_datasource/booking_remote_datasource.dart';
import '../data/remote_datasource_impl/booking_remote_datasource_impl.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../domain/repositories/booking_repository.dart';
import '../domain/usecases/get_booking_locations.dart';
import '../domain/usecases/get_booking_staffs.dart';
import '../domain/usecases/get_booking_service_detail.dart';

class BookingInjections {
  static void register() {
    // -----------------------------
    // Datasource
    // -----------------------------
    sl.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(sl<Dio>()),
    );

    // -----------------------------
    // Repository
    // -----------------------------
    sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(sl<BookingRemoteDataSource>()),
    );

    // -----------------------------
    // UseCases
    // -----------------------------
    sl.registerLazySingleton<GetBookingLocationsUseCase>(
      () => GetBookingLocationsUseCase(sl<BookingRepository>()),
    );

    sl.registerLazySingleton<GetBookingStaffsUseCase>(
      () => GetBookingStaffsUseCase(sl<BookingRepository>()),
    );

    sl.registerLazySingleton<GetBookingServiceDetailUseCase>(
      () => GetBookingServiceDetailUseCase(sl<BookingRepository>()),
    );

    // -----------------------------
    // Bloc
    // -----------------------------
    sl.registerCachedFactory<BookingsBloc>(
      () => BookingsBloc(
        getLocations: sl<GetBookingLocationsUseCase>(),
        getStaffs: sl<GetBookingStaffsUseCase>(),
        getServiceDetail: sl<GetBookingServiceDetailUseCase>(),
      ),
    );
  }
}
