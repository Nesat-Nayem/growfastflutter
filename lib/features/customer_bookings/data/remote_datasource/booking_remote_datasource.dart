import 'package:grow_first/features/customer_bookings/data/models/booking_location_model.dart';
import 'package:grow_first/features/customer_bookings/data/models/booking_service_detail_model.dart';
import 'package:grow_first/features/customer_bookings/data/models/booking_staff_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingLocationModel>> getLocations(int serviceId);

  Future<List<BookingStaffModel>> getStaffs({
    required int country,
    required int state,
    required int city,
    required int serviceId,
  });

  Future<List<BookingServiceDetailModel>> getServiceDetail(int serviceId);
}
