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

  Future<bool> confirmBooking({
    required int cartId,
    required String paymentMethod,
    required String paymentGateway,
    required dynamic response,
  });

  Future<int> addToCart({
    required int staffId,
    required int serviceId,
    required String bookingDate,
    required String bookingTime,
    required String bookingNotes,
    required List<int> additionalServiceIds,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String streetAddress,
    required String postalCode,
    required String country,
    required String state,
    required String city,
  });
}
