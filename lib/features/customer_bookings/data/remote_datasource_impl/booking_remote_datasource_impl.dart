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

    if (res is! Map) {
      throw Exception('Invalid response format: Expected a JSON object');
    }

    if (res['status'] != 'success') {
      throw Exception(res['message'] ?? 'Failed to fetch locations');
    }

    final data = res['data'];
    if (data == null) {
      return [];
    }

    if (data is! List) {
      throw Exception('Invalid response format: Expected data to be a list');
    }

    if (data.isEmpty) {
      return [];
    }

    return data.map((e) => BookingLocationModel.fromJson(e)).toList();
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

    if (res is! Map) {
      throw Exception('Invalid response format: Expected a JSON object');
    }

    if (res['status'] != 'success') {
      throw Exception(res['message'] ?? 'Failed to fetch staff');
    }

    final staffs = res['staffs'];
    if (staffs == null || staffs is! List) {
      return [];
    }

    if (staffs.isEmpty) {
      return [];
    }

    return staffs.map((e) => BookingStaffModel.fromJson(e)).toList();
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

    if (res is! Map) {
      throw Exception('Invalid response format: Expected a JSON object');
    }

    if (res['status'] != 'success') {
      throw Exception(res['message'] ?? 'Failed to fetch service details');
    }

    final service = res['service'];
    if (service == null || service is! Map) {
      return [];
    }

    // Try both camelCase and snake_case for compatibility
    final additionalServices = service['additional_services'] ?? service['additionalServices'];
    if (additionalServices == null || additionalServices is! List) {
      return [];
    }

    if (additionalServices.isEmpty) {
      return [];
    }

    return additionalServices
        .map((e) => BookingServiceDetailModel.fromJson(e))
        .toList();
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

  Future<Map<String, dynamic>> getServiceSlots(int serviceId) async {
    final getToken = await sl<ISecureStore>().read("token");
    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'customer/service/booking/service_slots/$serviceId',
      headers: {'Authorization': 'Bearer $getToken'},
    );

    if (res is! Map) {
      throw Exception('Invalid response format: Expected a JSON object');
    }

    if (res['status'] != 'success') {
      throw Exception(res['message'] ?? 'Failed to fetch service slots');
    }

    final data = res['data'];
    if (data == null || data is! List) {
      return {'slots': [], 'hasSlots': false};
    }

    return {'slots': data, 'hasSlots': data.isNotEmpty};
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

    if (res is! Map) {
      throw Exception('Invalid response format: Expected a JSON object');
    }

    if (res['success'] == true) {
      final cartId = res['cart_id'];
      if (cartId == null) {
        throw Exception('Cart ID not found in response');
      }
      return int.tryParse(cartId.toString()) ?? 0;
    } else {
      throw Exception(res['message'] ?? 'Failed to add to cart');
    }
  }
}
