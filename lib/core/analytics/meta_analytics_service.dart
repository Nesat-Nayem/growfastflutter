import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

class MetaAnalyticsService {
  MetaAnalyticsService._();
  static final MetaAnalyticsService instance = MetaAnalyticsService._();

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  /// Call once at app startup (after WidgetsFlutterBinding.ensureInitialized).
  /// setAutoLogAppEventsEnabled & setAdvertiserTracking are the only init
  /// methods available in facebook_app_events ^0.24.0.
  Future<void> initialize() async {
    try {
      await _facebookAppEvents.setAutoLogAppEventsEnabled(true);
      // On iOS this enables the IDFA collection (requires ATT permission in iOS 14+).
      // On Android this enables advertising ID collection.
      await _facebookAppEvents.setAdvertiserTracking(enabled: true);
      debugPrint('[Meta] SDK initialized');
    } catch (e) {
      debugPrint('[Meta] SDK initialization error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 1. First Open / App Launch
  // ─────────────────────────────────────────────────────────────────────────

  /// Log when the app is launched. Meta also auto-fires this internally,
  /// but the explicit call guarantees it appears in Events Manager.
  Future<void> logFirstOpen() async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_first_app_launch',
      );
      debugPrint('[Meta] Event: fb_mobile_first_app_launch');
    } catch (e) {
      debugPrint('[Meta] logFirstOpen error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 2. Login
  // ─────────────────────────────────────────────────────────────────────────

  /// Log a successful user login.
  /// [loginMethod] should be 'otp', 'google', or 'apple'.
  Future<void> logLogin({required String loginMethod}) async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_login',
        parameters: {
          'login_method': loginMethod,
        },
      );
      debugPrint('[Meta] Event: fb_mobile_login ($loginMethod)');
    } catch (e) {
      debugPrint('[Meta] logLogin error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. Purchase  (service booking payment)
  // ─────────────────────────────────────────────────────────────────────────

  /// Log a standard purchase event for service bookings.
  Future<void> logPurchase({
    required double amount,
    required String currency,
    String? contentType,
    String? contentId,
    String? paymentMethod,
  }) async {
    try {
      await _facebookAppEvents.logPurchase(
        amount: amount,
        currency: currency,
        parameters: {
          if (contentType != null) 'content_type': contentType,
          if (contentId != null) 'content_id': contentId,
          if (paymentMethod != null) 'payment_method': paymentMethod,
        },
      );
      debugPrint('[Meta] Event: Purchase $amount $currency');
    } catch (e) {
      debugPrint('[Meta] logPurchase error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 4. Subscribe (vendor plan purchase)
  // ─────────────────────────────────────────────────────────────────────────

  /// Log when a vendor subscribes to a plan.
  /// Uses the built-in logSubscribe (orderId, price, currency) from SDK ^0.24.0.
  /// Also fires logPurchase for paid plans so Meta can optimise ad delivery.
  Future<void> logVendorSubscribe({
    required double amount,
    required String currency,
    required String planName,
    required bool isFree,
  }) async {
    try {
      final orderId = 'plan_${planName.toLowerCase().replaceAll(' ', '_')}';

      // Built-in Subscribe event — appears as "Subscribe" in Events Manager.
      // For free plans pass price 0.
      await _facebookAppEvents.logSubscribe(
        orderId: orderId,
        price: amount,
        currency: currency,
      );

      // Also log as Purchase for value-based ad optimisation (paid plans only).
      if (!isFree && amount > 0) {
        await _facebookAppEvents.logPurchase(
          amount: amount,
          currency: currency,
          parameters: {
            'content_type': 'vendor_subscription',
            'plan_name': planName,
          },
        );
      }
      debugPrint('[Meta] Event: Subscribe plan=$planName amount=$amount');
    } catch (e) {
      debugPrint('[Meta] logVendorSubscribe error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. Vendor Registration Started
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logVendorRegistrationStarted() async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'vendor_registration_started',
      );
      debugPrint('[Meta] Event: vendor_registration_started');
    } catch (e) {
      debugPrint('[Meta] logVendorRegistrationStarted error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Clear user data on logout / account switch.
  Future<void> clearUserData() async {
    try {
      await _facebookAppEvents.clearUserData();
      debugPrint('[Meta] User data cleared');
    } catch (e) {
      debugPrint('[Meta] clearUserData error: $e');
    }
  }
}
