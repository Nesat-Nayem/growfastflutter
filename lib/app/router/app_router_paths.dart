import 'package:grow_first/app/router/app_router_name.dart';

class AppRouterPaths {
  static String splashPath = '/${AppRouterNames.splash}';

  static String signInPath = '/${AppRouterNames.signIn}';

  static String signUpPath = '/${AppRouterNames.signUp}';

  static String verifyOtpPath =
      '/${AppRouterNames.verifyOtp}/:process_initiated_on';

  static String homePath = '/${AppRouterNames.home}';

  static String exploreCategoriesPath = '/${AppRouterNames.exploreCategories}';

  static String listingsPath = '/${AppRouterNames.listings}';

  static String listingsFiltersPath = '/${AppRouterNames.listingsFilters}';

  static String listingDetailPath =
      '/${AppRouterNames.listingDetail}/:listingId';

  static String contactSupplierPath =
      '/${AppRouterNames.contactSupplier}/:listingId';

  static String customerHomePath = '/${AppRouterNames.customerHome}';

  static String customerBookingsPath = '/${AppRouterNames.customerBookings}';

  static String customerBookingDetailPath =
      '/${AppRouterNames.customerBookingDetail}/:bookingId';

  static String customerSelectBookingLocationPath =
      '/${AppRouterNames.customerSelectBookingLocation}/:listingId';

  static String customerSelectBookingStaffPath =
      '/${AppRouterNames.customerSelectBookingStaff}/:listingId/:locationId';

  static String customerSelectAdditionalServiceBookingPath =
      '/${AppRouterNames.customerSelectAdditionalServiceBooking}/:listingId/:locationId/:staffId';

  static String customerSelectDateAndTimeForBookingPath =
      '/${AppRouterNames.customerSelectDateAndTimeForBooking}/:listingId/:locationId/:staffId';

  static String customerBookingAddPersonalInformationPath =
      '/${AppRouterNames.customerBookingAddPersonalInformation}/:listingId/:locationId/:staffId';

  static String customerCartPath = '/${AppRouterNames.customerCart}';

  static String customerPaymentModePath =
      '/${AppRouterNames.customerPaymentMode}';

  static String customerBookingConfirmedPath =
      '/${AppRouterNames.customerBookingConfirmed}';

  static String customerWalletPath = '/${AppRouterNames.customerWallet}';

  static String myReviewPath = '/${AppRouterNames.myReview}';

  static String accountSettingsPath = '/${AppRouterNames.accountSettings}';

  static String vendorWebViewPath = '/${AppRouterNames.vendorWebView}';

  static String dashboardPath = '/${AppRouterNames.dashboard}';

  static String searchPath = '/${AppRouterNames.search}';

  static String ModernCustomerDrawerPath= '/${AppRouterNames.ModernCustomerDrawer}';

  static String vendorAboutPath = '/${AppRouterNames.vendorAbout}';

  static String vendorDashboardPath = '/${AppRouterNames.vendorDashboard}';

  static String vendorChoosePlanPath = '/${AppRouterNames.vendorChoosePlan}';

  static String vendorKycFormPath = '/${AppRouterNames.vendorKycForm}';

  static String vendorConfirmRegistrationPath = '/${AppRouterNames.vendorConfirmRegistration}';
}
