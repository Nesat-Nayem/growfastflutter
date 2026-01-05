import 'package:dio/dio.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/features/cart/data/models/cart_model.dart';

class CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getCartList() async {
    final getToken = await sl<ISecureStore>().read("token");
    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'customer/cart-list',
      headers: {'Authorization': 'Bearer $getToken'},
    );

    if (res is! Map) {
      throw Exception('Invalid response format: Expected a JSON object');
    }

    if (res['success'] != true) {
      throw Exception(res['message'] ?? 'Failed to fetch cart');
    }

    final carts = res['carts'];
    if (carts == null || carts is! List) {
      return {
        'carts': <CartModel>[],
        'totalAmount': 0.0,
        'selectedCartId': null,
      };
    }

    return {
      'carts': carts.map((e) => CartModel.fromJson(e)).toList(),
      'totalAmount': double.tryParse(res['totalAmount']?.toString() ?? '0') ?? 0.0,
      'selectedCartId': res['selectedCartId'],
    };
  }

  Future<bool> removeCartItem(int cartId) async {
    final getToken = await sl<ISecureStore>().read("token");
    final res = await NetworkHelper.sendRequest(
      dio,
      RequestType.delete,
      'customer/cart-delete/$cartId',
      headers: {'Authorization': 'Bearer $getToken'},
    );

    if (res is! Map) {
      throw Exception('Invalid response format');
    }

    return res['status'] == 'success' || res['success'] == true;
  }
}
