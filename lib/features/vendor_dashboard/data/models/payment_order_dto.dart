class PaymentOrderRequest {
  final int vendorId;
  final int planId;
  final String gateway;

  PaymentOrderRequest({
    required this.vendorId,
    required this.planId,
    this.gateway = 'razorpay',
  });

  Map<String, dynamic> toJson() => {
    'vendor_id': vendorId,
    'plan_id': planId,
    'gateway': gateway,
  };
}

class PaymentOrderResponse {
  final String status;
  final String gateway;
  final String orderId;
  final int amount;
  final String? key;
  final String? paymentUrl;
  final String? paymentSessionId;
  final String? environment;

  PaymentOrderResponse({
    required this.status,
    required this.gateway,
    required this.orderId,
    required this.amount,
    this.key,
    this.paymentUrl,
    this.paymentSessionId,
    this.environment,
  });

  factory PaymentOrderResponse.fromJson(Map<String, dynamic> json) {
    return PaymentOrderResponse(
      status: json['status'] ?? '',
      gateway: json['gateway'] ?? 'razorpay',
      orderId: json['order_id'] ?? '',
      amount: json['amount'] ?? 0,
      key: json['key'],
      paymentUrl: json['payment_url'],
      paymentSessionId: json['payment_session_id'],
      environment: json['environment'],
    );
  }
}

class StorePaymentRequest {
  final int planId;
  final String transactionId;

  StorePaymentRequest({
    required this.planId,
    required this.transactionId,
  });

  Map<String, dynamic> toJson() => {
    'plan_id': planId,
    'transaction_id': transactionId,
  };
}

class StorePaymentResponse {
  final String status;
  final String message;

  StorePaymentResponse({
    required this.status,
    required this.message,
  });

  factory StorePaymentResponse.fromJson(Map<String, dynamic> json) {
    return StorePaymentResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
