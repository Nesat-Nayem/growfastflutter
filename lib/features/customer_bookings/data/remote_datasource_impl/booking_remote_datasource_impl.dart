import 'package:dio/dio.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/features/customer_bookings/data/models/booking_location_model.dart';
import 'package:grow_first/features/customer_bookings/data/models/booking_service_detail_model.dart';
import 'package:grow_first/features/customer_bookings/data/models/booking_staff_model.dart';
import 'package:grow_first/features/customer_bookings/data/remote_datasource/booking_remote_datasource.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio dio;

  BookingRemoteDataSourceImpl(this.dio);

  @override
  Future<List<BookingLocationModel>> getLocations(int serviceId) async {
    final getToken = await sl<ISecureStore>().read("token");
    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      headers: {'Authorization': 'Bearer $getToken'},
      'customer/service/booking/locations/$serviceId',
    );

    return (res['staffLocations'] as List)
        .map((e) => BookingLocationModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<BookingStaffModel>> getStaffs({
    required int country,
    required int state,
    required int city,
    required int serviceId,
  }) async {
    final getToken = await sl<ISecureStore>().read("token");

    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'customer/service/booking/staffs',
      headers: {'Authorization': 'Bearer $getToken'},
      data: {
        'country': country,
        'state': state,
        'city': city,
        'service_id': serviceId,
      },
    );

    return (res['staffs'] as List)
        .map((e) => BookingStaffModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<BookingServiceDetailModel>> getServiceDetail(
    int serviceId,
  ) async {
    final getToken = await sl<ISecureStore>().read("token");
    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'customer/service/booking/service_details/$serviceId',
      headers: {'Authorization': 'Bearer $getToken'},
    );

    final List<BookingServiceDetailModel> services =
        (res['service']['additional_services'] as List)
            .map((e) => BookingServiceDetailModel.fromJson(e))
            .toList();

    return services;
  }

  @override
  Future<bool> confirmBooking({
    required int cartId,
    required String paymentMethod,
    required String paymentGateway,
    required dynamic response,
  }) async {
    final getToken = await sl<ISecureStore>().read("token");
    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'booking/payment-success',
      headers: {'Authorization': 'Bearer $getToken'},
      data: {
        'cart_id': cartId,
        'payment_method': paymentMethod,
        'payment_gateway': paymentGateway,
        'response': response,
      },
    );

    return res['success'] == true;
  }

  @override
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
  }) async {
    final getToken = await sl<ISecureStore>().read("token");
    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'customer/cart-add',
      headers: {'Authorization': 'Bearer $getToken'},
      data: {
        'staff_id': staffId,
        'service_id': serviceId,
        'booking_date': bookingDate,
        'booking_time': bookingTime,
        'booking_notes': bookingNotes,
        'additional_service_ids': additionalServiceIds,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'street_address': streetAddress,
        'postal_code': postalCode,
        'country': country,
        'state': state,
        'city': city,
      },
    );

    if (res['success'] == true) {
      return res['cart_id'];
    } else {
      throw Exception(res['message'] ?? 'Failed to add to cart');
    }
  }
}
