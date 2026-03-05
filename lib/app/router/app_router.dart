import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/app/router/app_router_paths.dart';
import 'package:grow_first/app/router/refresh_streams/go_router_refresh_stream.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/features/account/presentation/customer_account_settings.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';
import 'package:grow_first/features/auth/presentation/signin_page.dart';
import 'package:grow_first/features/auth/presentation/verify_otp_page.dart';
import 'package:grow_first/features/bottom_navigation_bar_wrapper.dart';
import 'package:grow_first/features/cart/presentation/cart_page.dart';
import 'package:grow_first/features/categories/explore_categories_page.dart';
import 'package:grow_first/features/customer_bookings/presentation/customer_booking_add_personal_information.dart';
import 'package:grow_first/features/customer_bookings/presentation/customer_booking_additional_service_page.dart';
import 'package:grow_first/features/customer_bookings/presentation/customer_booking_confirmed_page.dart';
import 'package:grow_first/features/customer_bookings/presentation/customer_select_booking_location_page.dart';
import 'package:grow_first/features/customer_bookings/presentation/customer_select_booking_staff_page.dart';
import 'package:grow_first/features/customer_bookings/presentation/customer_select_data_and_time_for_booking_page.dart';
import 'package:grow_first/features/customer_home/presentation/customer_home_page.dart';
import 'package:grow_first/features/customer_bookings/presentation/booking_detail_page.dart';
import 'package:grow_first/features/customer_bookings/presentation/customer_bookings.dart';
import 'package:grow_first/features/home/presentation/home_page.dart';
import 'package:grow_first/features/listing/presentation/contact_supplier_page.dart';
import 'package:grow_first/features/listing/presentation/listing_detail_page.dart';
import 'package:grow_first/features/listing/presentation/listing_filters_page.dart';
import 'package:grow_first/features/listing/presentation/listing_page.dart';
import 'package:grow_first/features/listing/presentation/search_page.dart';
import 'package:grow_first/features/listing/domain/entities/listing_filter_params.dart';
import 'package:grow_first/features/payment/presentation/payment_mode_page.dart';
import 'package:grow_first/features/reviews/presentation/my_reviews_page.dart';
import 'package:grow_first/features/splash/splash_page.dart';
import 'package:grow_first/features/wallet/presentation/customer_wallet_page.dart';
import 'package:grow_first/features/webview/vendor_webview_page.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vendor_about_page.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vender_dashboard_page.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vendor_registration_choose_plan.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vendor_registration_kyc.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vendor_confirm_registration.dart';
import '../bloc/app_bloc/app_bloc.dart';

class AppRouter {
  static List<String> unAuthenticatedPaths = [
    AppRouterPaths.signInPath,
    AppRouterPaths.signUpPath,
    AppRouterPaths.verifyOtpPath,
    AppRouterPaths.homePath,
    AppRouterPaths.exploreCategoriesPath,
    AppRouterPaths.listingsPath,
    AppRouterPaths.listingDetailPath,
    AppRouterPaths.listingsFiltersPath,
    AppRouterPaths.contactSupplierPath,
    AppRouterPaths.customerHomePath,
    AppRouterPaths.customerBookingsPath,
    AppRouterPaths.customerSelectBookingLocationPath,
    AppRouterPaths.customerSelectDateAndTimeForBookingPath,
    AppRouterPaths.customerSelectBookingStaffPath,
    AppRouterPaths.customerSelectAdditionalServiceBookingPath,
    AppRouterPaths.customerBookingAddPersonalInformationPath,
    AppRouterPaths.customerCartPath,
    AppRouterPaths.customerPaymentModePath,
    AppRouterPaths.customerBookingConfirmedPath,
    AppRouterPaths.customerBookingDetailPath,
    AppRouterPaths.customerWalletPath,
    AppRouterPaths.searchPath,
    AppRouterPaths.myReviewPath,
    AppRouterPaths.accountSettingsPath,
    AppRouterPaths.accountSettingsPath,
    AppRouterPaths.ModernCustomerDrawerPath,
    AppRouterPaths.vendorWebViewPath,
    AppRouterPaths.vendorAboutPath,
    AppRouterPaths.vendorDashboardPath,
    AppRouterPaths.vendorChoosePlanPath,
    AppRouterPaths.vendorKycFormPath,
    AppRouterPaths.vendorConfirmRegistrationPath,
  ];

  static GoRouter buildRouter(AppBloc appBloc) {
    return GoRouter(
      initialLocation: AppRouterPaths.splashPath,
      refreshListenable: BlocRefreshStream(appBloc.stream),
      redirect: (context, state) async {
        final appState = appBloc.state;

        final bool isLoggedIn =
            await sl<ISecureStore>().read("isLoggedIn") == "true";

        if (!isLoggedIn && !unAuthenticatedPaths.contains(state.fullPath)) {
          // return '/vendor-dashboard';
          // return '/vendor-choose-plan';
          // return '/vendor-kyc-form';
          // return '/vendor-confirm-registration';
          // return AppRouterPaths.signInPath;
          return AppRouterPaths.splashPath;
          // return AppRouterPaths.customerSelectBookingLocationPath.replaceAll(
          //   ":bookingId",
          //   "234",
          // );
        }

        if (appState is AppAuthenticated &&
            unAuthenticatedPaths.contains(state.path)) {
          return AppRouterPaths.dashboardPath;
        }

        return null;
      },
      routes: [
        GoRoute(
          name: AppRouterNames.splash,
          path: AppRouterPaths.splashPath,
          builder: (_, __) => const SplashPage(),
        ),
        GoRoute(
          name: AppRouterNames.signIn,
          path: AppRouterPaths.signInPath,
          builder: (_, state) => BlocProvider.value(
            value: sl<CountryCubit>(),
            child: SigninPage(
              redirectionData: state.extra as Map<String, dynamic>?,
            ),
          ),
        ),
        GoRoute(
          name: AppRouterNames.verifyOtp,
          path: AppRouterPaths.verifyOtpPath,
          builder: (_, state) => VerifyOtpPage(
            processInitaiedOn:
                state.pathParameters['process_initiated_on'] ?? "",
            redirectionData: state.extra as Map<String, dynamic>?,
          ),
        ),
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) {
            return CupertinoPage(
              key: state.pageKey,
              child: BottomNavigationBarWrapper(
                navigationShell: navigationShell,
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouterNames.home,
                  path: AppRouterPaths.homePath,
                  builder: (_, state) => HomePage(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouterNames.exploreCategories,
                  path: AppRouterPaths.exploreCategoriesPath,
                  builder: (_, state) => ExploreCategoriesPage(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouterNames.customerHome,
                  path: AppRouterPaths.customerHomePath,
                  builder: (_, state) => CustomerHomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouterNames.listings,
                  path: AppRouterPaths.listingsPath,
                  builder: (_, state) => ListingPage(
                    categoryId:
                        state.uri.queryParametersAll.containsKey("categoryId")
                        ? state.uri.queryParameters["categoryId"].toString()
                        : null,
                    subcategoryId:
                        state.uri.queryParametersAll.containsKey(
                          "subcategoryId",
                        )
                        ? state.uri.queryParameters["subcategoryId"].toString()
                        : null,
                    serviceType:
                        state.uri.queryParametersAll.containsKey("service_type")
                        ? state.uri.queryParameters["service_type"].toString()
                        : null,
                    keyword: state.uri.queryParametersAll.containsKey("keyword")
                        ? state.uri.queryParameters["keyword"].toString()
                        : null,
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouterNames.customerBookings,
                  path: AppRouterPaths.customerBookingsPath,
                  builder: (_, state) => CustomerBookingsPage(),
                ),
              ],
            ),
            // StatefulShellBranch(
            //   routes: [
            //     GoRoute(
            //       name: 'bookings',
            //       path: '/bookings',
            //       redirect: (context, state) {
            //         return "/bookings/${AppRouterNames.customerBookingDetail}/${state.pathParameters['bookingId']}";
            //       },
            //       routes: [

            //       ],
            //     ),
            //   ],
            // ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouterNames.customerWallet,
                  path: AppRouterPaths.customerWalletPath,
                  builder: (_, state) => CustomerWalletPage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: AppRouterNames.accountSettings,
          path: AppRouterPaths.accountSettingsPath,
          builder: (_, state) => CustomerAccountSettings(),
        ),
        GoRoute(
          name: AppRouterNames.ModernCustomerDrawer,
          path: AppRouterPaths.ModernCustomerDrawerPath,
          builder: (_, state) => ModernCustomerDrawer(),
        ),
        GoRoute(
          name: AppRouterNames.myReview,
          path: AppRouterPaths.myReviewPath,
          builder: (_, state) => MyReviewsPage(),
        ),
        GoRoute(
          name: AppRouterNames.customerBookingDetail,
          path: AppRouterPaths.customerBookingDetailPath,
          builder: (_, state) => BookingDetailPage(
            bookingId: state.pathParameters["bookingId"].toString(),
          ),
        ),
        GoRoute(
          name: AppRouterNames.listingsFilters,
          path: AppRouterPaths.listingsFiltersPath,
          builder: (_, state) => ListingFiltersPage(
            initialFilters: state.extra as ListingFilterParams?,
          ),
        ),
        GoRoute(
          name: AppRouterNames.listingDetail,
          path: AppRouterPaths.listingDetailPath,
          builder: (_, state) => ListingDetailPage(
            listingId: state.pathParameters['listingId'].toString(),
          ),
        ),
        GoRoute(
          name: AppRouterNames.contactSupplier,
          path: AppRouterPaths.contactSupplierPath,
          builder: (_, state) => ContactSupplierPage(
            listingId: state.pathParameters['listingId'].toString(),
          ),
        ),
        GoRoute(
          name: AppRouterNames.customerSelectBookingLocation,
          path: AppRouterPaths.customerSelectBookingLocationPath,
          builder: (_, state) => CustomerSelectBookingLocationPage(
            listingId: state.pathParameters['listingId'].toString(),
          ),
        ),
        GoRoute(
          name: AppRouterNames.customerSelectBookingStaff,
          path: AppRouterPaths.customerSelectBookingStaffPath,
          builder: (_, state) => CustomerSelectBookingStaffPage(
            listingId: state.pathParameters['listingId'].toString(),
            locationId: state.pathParameters['locationId'].toString(),
          ),
        ),
        GoRoute(
          name: AppRouterNames.customerSelectAdditionalServiceBooking,
          path: AppRouterPaths.customerSelectAdditionalServiceBookingPath,
          builder: (_, state) => CustomerBookingAdditionalServicePage(
            listingId: state.pathParameters['listingId'].toString(),
            locationId: state.pathParameters['locationId'].toString(),
            staffId: state.pathParameters['staffId'].toString(),
          ),
        ),
        GoRoute(
          name: AppRouterNames.customerSelectDateAndTimeForBooking,
          path: AppRouterPaths.customerSelectDateAndTimeForBookingPath,
          builder: (_, state) => CustomerSelectDataAndTimeForBookingPage(
            listingId: state.pathParameters['listingId'].toString(),
            locationId: state.pathParameters['locationId'].toString(),
            staffId: state.pathParameters['staffId'].toString(),
          ),
        ),
        GoRoute(
          name: AppRouterNames.customerBookingAddPersonalInformation,
          path: AppRouterPaths.customerBookingAddPersonalInformationPath,
          builder: (_, state) => CustomerBookingAddPersonalInformation(
            listingId: state.pathParameters['listingId'].toString(),
            locationId: state.pathParameters['locationId'].toString(),
            staffId: state.pathParameters['staffId'].toString(),
            date: state.uri.queryParameters['date'] ?? "",
            time: state.uri.queryParameters['time'] ?? "",
          ),
        ),
        GoRoute(
          name: AppRouterNames.customerCart,
          path: AppRouterPaths.customerCartPath,
          builder: (_, state) => CartPage(),
        ),
        GoRoute(
          name: AppRouterNames.customerPaymentMode,
          path: AppRouterPaths.customerPaymentModePath,
          builder: (_, state) =>
              PaymentModePage(cartId: state.uri.queryParameters['cartId']),
        ),
        GoRoute(
          name: AppRouterNames.customerBookingConfirmed,
          path: AppRouterPaths.customerBookingConfirmedPath,
          builder: (_, state) => CustomerBookingConfirmedPage(
            bookingDate: state.uri.queryParameters['date'],
            bookingTime: state.uri.queryParameters['time'],
            bookingRef: state.uri.queryParameters['ref'],
          ),
        ),
        GoRoute(
          name: AppRouterNames.vendorWebView,
          path: AppRouterPaths.vendorWebViewPath,
          builder: (_, state) => VendorWebViewPage(
            url:
                state.uri.queryParameters['url'] ??
                'http://public.test/become-vendor',
            title: state.uri.queryParameters['title'] ?? 'Become a Vendor',
          ),
        ),
        GoRoute(
          name: AppRouterNames.search,
          path: AppRouterPaths.searchPath,
          builder: (_, state) => const SearchPage(),
        ),
        GoRoute(
          name: AppRouterNames.vendorAbout,
          path: AppRouterPaths.vendorAboutPath,
          builder: (_, state) => const VendorAboutPage(),
        ),
        GoRoute(
          name: AppRouterNames.vendorDashboard,
          path: AppRouterPaths.vendorDashboardPath,
          builder: (_, state) => const VendorDashboardPage(),
        ),
        GoRoute(
          name: AppRouterNames.vendorChoosePlan,
          path: AppRouterPaths.vendorChoosePlanPath,
          builder: (_, state) => const VendorRegistrationChoosePlan(),
        ),
        GoRoute(
          name: AppRouterNames.vendorKycForm,
          path: AppRouterPaths.vendorKycFormPath,
          builder: (_, state) => const VendorUploadKycPage(),
        ),
        GoRoute(
          name: AppRouterNames.vendorConfirmRegistration,
          path: AppRouterPaths.vendorConfirmRegistrationPath,
          builder: (_, state) => const VendorConfirmRegistration(),
        ),
      ],
    );
  }
}
