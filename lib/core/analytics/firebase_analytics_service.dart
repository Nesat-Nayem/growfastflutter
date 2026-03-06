import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsService {
  FirebaseAnalyticsService._();
  static final FirebaseAnalyticsService instance = FirebaseAnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ─────────────────────────────────────────────────────────────────────────
  // Screen Tracking
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logScreenView({required String screenName}) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
      debugPrint('[Firebase] Screen: $screenName');
    } catch (e) {
      debugPrint('[Firebase] logScreenView error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Login
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logLogin({required String loginMethod}) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
      debugPrint('[Firebase] Event: login ($loginMethod)');
    } catch (e) {
      debugPrint('[Firebase] logLogin error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Sign Up
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logSignUp({required String signUpMethod}) async {
    try {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
      debugPrint('[Firebase] Event: sign_up ($signUpMethod)');
    } catch (e) {
      debugPrint('[Firebase] logSignUp error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Purchase (Service Booking Payment)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logPurchase({
    required double amount,
    required String currency,
    String? paymentMethod,
    String? transactionId,
  }) async {
    try {
      await _analytics.logPurchase(
        currency: currency,
        value: amount,
        transactionId: transactionId,
        parameters: {
          if (paymentMethod != null) 'payment_method': paymentMethod,
        },
      );
      debugPrint('[Firebase] Event: purchase $amount $currency');
    } catch (e) {
      debugPrint('[Firebase] logPurchase error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Vendor Subscription
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logVendorSubscribe({
    required double amount,
    required String currency,
    required String planName,
    required bool isFree,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'vendor_subscribe',
        parameters: {
          'plan_name': planName,
          'amount': amount,
          'currency': currency,
          'is_free': isFree ? 'yes' : 'no',
        },
      );
      debugPrint('[Firebase] Event: vendor_subscribe plan=$planName amount=$amount');
    } catch (e) {
      debugPrint('[Firebase] logVendorSubscribe error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Begin Checkout (when user goes to payment page)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logBeginCheckout({
    required double amount,
    required String currency,
  }) async {
    try {
      await _analytics.logBeginCheckout(
        currency: currency,
        value: amount,
      );
      debugPrint('[Firebase] Event: begin_checkout $amount $currency');
    } catch (e) {
      debugPrint('[Firebase] logBeginCheckout error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Vendor Registration Started
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logVendorRegistrationStarted() async {
    try {
      await _analytics.logEvent(name: 'vendor_registration_started');
      debugPrint('[Firebase] Event: vendor_registration_started');
    } catch (e) {
      debugPrint('[Firebase] logVendorRegistrationStarted error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Ad Impression (for tracking ad revenue)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logAdImpression({
    required String adPlatform,
    required String adFormat,
    required String adUnitName,
  }) async {
    try {
      await _analytics.logAdImpression(
        adPlatform: adPlatform,
        adFormat: adFormat,
        adUnitName: adUnitName,
      );
      debugPrint('[Firebase] Event: ad_impression ($adUnitName)');
    } catch (e) {
      debugPrint('[Firebase] logAdImpression error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Custom Event
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      debugPrint('[Firebase] Event: $name');
    } catch (e) {
      debugPrint('[Firebase] logCustomEvent error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // User Properties
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('[Firebase] UserId set: $userId');
    } catch (e) {
      debugPrint('[Firebase] setUserId error: $e');
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('[Firebase] UserProperty: $name = $value');
    } catch (e) {
      debugPrint('[Firebase] setUserProperty error: $e');
    }
  }
}
