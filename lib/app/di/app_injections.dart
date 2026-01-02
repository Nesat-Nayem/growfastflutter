import 'package:get_it/get_it.dart';
import 'package:grow_first/app/bloc/app_bloc/app_bloc.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/network/dio_client.dart';
import 'package:grow_first/core/sessions/session_manager.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/features/auth/di/injections.dart';
import 'package:grow_first/features/categories/di/injections.dart';
import 'package:grow_first/features/customer_bookings/di/booking_injections.dart';
import 'package:grow_first/features/home/di/injections.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';
import 'package:grow_first/features/vendor_dashboard/di/vendors_injections.dart';

final sl = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  // Core
  sl.registerSingleton<AppConfig>(config);
  sl.registerLazySingleton<ISecureStore>(() => SecureStore());
  sl.registerSingleton<SessionManager>(SessionManager());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl<AppConfig>(), sl<ISecureStore>(), sl()),
  );

  //Bloc
  sl.registerFactory(() => AppBloc(secureStore: sl<ISecureStore>()));

  // Auth Injections
  AuthInjections.register();

  HomeInjections.register();

  CategoryInjections.register();

  ListingInjections.register();

  BookingInjections.register();

  VendorInjections.register();
}
