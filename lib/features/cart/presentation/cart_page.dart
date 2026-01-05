import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/cart/data/models/cart_model.dart';
import 'package:grow_first/features/cart/data/remote_datasource/cart_remote_datasource.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> carts = [];
  int? selectedCartId;
  double totalAmount = 0.0;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    try {
      final dio = sl<Dio>();
      final dataSource = CartRemoteDataSource(dio);
      final result = await dataSource.getCartList();

      setState(() {
        carts = result['carts'] as List<CartModel>;
        totalAmount = result['totalAmount'] as double;
        selectedCartId = result['selectedCartId'] as int?;
        if (selectedCartId == null && carts.isNotEmpty) {
          selectedCartId = carts.first.id;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _removeCartItem(int cartId) async {
    try {
      final dio = sl<Dio>();
      final dataSource = CartRemoteDataSource(dio);
      await dataSource.removeCartItem(cartId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
      
      _fetchCartData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "Cart"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "Cart"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              verticalMargin16,
              Text(
                'Failed to load cart',
                style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              verticalMargin8,
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: context.bodySmall,
              ),
              verticalMargin16,
              GradientButton(
                text: 'Retry',
                onTap: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _fetchCartData();
                },
              ),
            ],
          ),
        ),
      );
    }

    if (carts.isEmpty) {
      return Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "Cart"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
              verticalMargin16,
              Text(
                'Your Cart is Empty',
                style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              verticalMargin8,
              Text(
                'Add services to your cart to continue',
                textAlign: TextAlign.center,
                style: context.bodySmall.copyWith(color: Colors.grey),
              ),
              verticalMargin24,
              GradientButton(
                text: 'Browse Services',
                onTap: () => context.goNamed(AppRouterNames.home),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Cart"),
      body: Padding(
        padding: horizontalPadding16,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  final cart = carts[index];
                  final isSelected = selectedCartId == cart.id;
                  return CartItem(
                    cart: cart,
                    isSelected: isSelected,
                    onSelect: () {
                      setState(() {
                        selectedCartId = cart.id;
                      });
                    },
                    onRemove: () => _removeCartItem(cart.id),
                  );
                },
              ),
            ),
            verticalMargin16,
            Container(
              padding: allPadding16,
              decoration: BoxDecoration(
                color: greyButttonColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '₹ ${selectedCartId != null ? carts.firstWhere((c) => c.id == selectedCartId).totalPrice.toStringAsFixed(2) : "0.00"}',
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: violetBlueColor,
                    ),
                  ),
                ],
              ),
            ),
            verticalMargin8,
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavNextBackBtns(
        onPressedOne: selectedCartId != null
            ? () {
                context.pushNamed(
                  AppRouterNames.customerPaymentMode,
                  queryParameters: {'cartId': selectedCartId.toString()},
                );
              }
            : null,
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final CartModel cart;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.cart,
    required this.isSelected,
    required this.onSelect,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bookingTime = cart.bookingSlots != null && cart.bookingSlots!.isNotEmpty
        ? cart.bookingSlots!.replaceAll('"', '')
        : 'Not specified';

    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(cart.bookingDate);
    } catch (e) {
      parsedDate = null;
    }

    final formattedDate = parsedDate != null
        ? DateFormat('EEE, dd MMM yyyy').format(parsedDate)
        : cart.bookingDate;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: bottomPadding12,
        padding: topPadding16,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? violetBlueColor : greyButttonColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: horizontalPadding16,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: cart.service?.image != null
                            ? CachedNetworkImage(
                                imageUrl: cart.service!.image!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  width: 50,
                                  height: 50,
                                  color: greyButttonColor,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: greyButttonColor,
                                child: const Icon(Icons.business),
                              ),
                      ),
                      horizontalMargin12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cart.service?.title ?? 'Service',
                              style: context.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (cart.cartItems.isNotEmpty) ...[
                              verticalMargin4,
                              Text(
                                '${cart.cartItems.length} additional service(s)',
                                style: context.labelSmall.copyWith(
                                  color: lightGreyTextColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, color: violetBlueColor, size: 24),
                    ],
                  ),
                  verticalMargin8,
                  Divider(color: greyButttonColor),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Staff", style: context.labelLarge),
                            verticalMargin4,
                            Text(
                              cart.staffName ?? 'Not assigned',
                              style: context.labelMedium.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date & Time", style: context.labelLarge),
                            verticalMargin4,
                            Text(
                              '$formattedDate\n$bookingTime',
                              style: context.labelMedium.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (cart.address != null) ...[
                    Divider(color: greyButttonColor),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location", style: context.labelLarge),
                              verticalMargin4,
                              Text(
                                cart.address!.address,
                                style: context.labelMedium.copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  verticalMargin8,
                  Row(
                    children: [
                      Expanded(child: Text("Amount", style: context.labelLarge)),
                      Text.rich(
                        TextSpan(
                          text: "₹ ",
                          children: [
                            TextSpan(
                              text: cart.totalPrice.toStringAsFixed(2),
                              style: context.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalMargin8,
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: GradientButton(
                text: "Remove",
                onTap: onRemove,
                borderRadius: 0,
                textStyle: context.labelLarge.copyWith(color: lavaRedColor),
                hideGradient: true,
                iconWithTitle: const Icon(
                  Icons.delete_forever,
                  size: 18,
                  color: lavaRedColor,
                ),
                showIconFirst: true,
                backgroundColor: lavaRedColor.withOpacity(0.09),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
