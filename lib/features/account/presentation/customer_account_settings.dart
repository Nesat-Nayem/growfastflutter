import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/account/data/remote_datasource/account_remote_datasource.dart';
import 'package:grow_first/features/account/presentation/bloc/account_cubit.dart';
import 'package:grow_first/features/account/presentation/widgets/country_state_selection.dart';
import 'package:grow_first/features/account/presentation/widgets/date_of_bith_drop_down.dart';
import 'package:grow_first/features/account/presentation/widgets/gender_drop_down.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';
import 'package:grow_first/features/widgets/custom_textfield.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:dio/dio.dart';
import 'package:sizer/sizer.dart';

class CustomerAccountSettings extends StatefulWidget {
  const CustomerAccountSettings({super.key});

  @override
  State<CustomerAccountSettings> createState() => _CustomerAccountSettingsState();
}

class _CustomerAccountSettingsState extends State<CustomerAccountSettings> {
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  
  late AccountCubit _accountCubit;

  @override
  void initState() {
    super.initState();
    _accountCubit = AccountCubit(
      AccountRemoteDataSourceImpl(sl<Dio>()),
      sl<AppStore>(),
    );
    // Check if user is logged in
    final appStore = sl<AppStore>();
    if (!appStore.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(AppRouterNames.signIn);
      });
    } else {
      _accountCubit.loadProfile();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _accountCubit.close();
    super.dispose();
  }

  void _populateFields(Map<String, dynamic> user) {
    _nameController.text = user['name'] ?? '';
    _userNameController.text = user['user_name'] ?? '';
    _emailController.text = user['email'] ?? '';
    _phoneController.text = user['phone'] ?? '';
    _addressController.text = user['address'] ?? '';
    _cityController.text = user['city'] ?? '';
    _postalCodeController.text = user['post_code'] ?? '';
  }

  void _saveChanges() {
    final data = {
      'name': _nameController.text,
      'user_name': _userNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'post_code': _postalCodeController.text,
    };
    _accountCubit.updateProfile(data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _accountCubit,
      child: Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "Account Settings"),
        drawer: ModernCustomerDrawer(),
        body: BlocConsumer<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state is AccountLoaded) {
              _populateFields(state.user);
            }
            if (state is AccountUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
              _populateFields(state.user);
            }
            if (state is AccountError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AccountLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: horizontalPadding16,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalMargin8,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://picsum.photos/seed/avatar2/100/100",
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  horizontalMargin16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                                  allPadding8 +
                                  horizontalPadding12 +
                                  verticalPadding4 / 2,
                              decoration: BoxDecoration(
                                color: textBlackColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.iconUploadCloudSvg,
                                    height: 18,
                                  ),
                                  horizontalMargin8,
                                  Text(
                                    "Upload",
                                    style: context.labelSmall.copyWith(
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            horizontalMargin12,
                            Container(
                              padding:
                                  allPadding8 +
                                  horizontalPadding24 +
                                  verticalPadding4 / 2,
                              decoration: BoxDecoration(
                                color: greyButttonColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text("Remove", style: context.labelSmall),
                            ),
                          ],
                        ),
                        verticalMargin8,
                        Text(
                          "*Image size should be at least 320px big and less that 500kb. Allowed files .png and .jpg",
                          style: context.labelSmall.copyWith(
                            color: lavaRedColor.withValues(alpha: 0.4),
                            fontSize: 12.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalMargin16,
              Text(
                "General Information",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              Text(
                "Name",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(
                controller: _nameController,
                hintText: "Enter your name",
              ),
              verticalMargin16,
              Text(
                "User Name",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(
                controller: _userNameController,
                hintText: "Enter username",
              ),
              verticalMargin16,
              Text(
                "Email",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(
                controller: _emailController,
                hintText: "Enter email",
              ),
              verticalMargin16,
              Text(
                "Mobile Number",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(
                controller: _phoneController,
                hintText: "Enter phone number",
              ),
              verticalMargin16,
              Text(
                "Gender",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              GenderDropdown(),
              verticalMargin16,
              Text(
                "Date of Birth",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              DatePickerField(),
              verticalMargin16,
              Text(
                "Address",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              Text(
                "Address",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(
                controller: _addressController,
                hintText: "Enter address",
              ),
              verticalMargin16,
              CountryStateSection(),
              verticalMargin16,
              Text(
                "City",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              CustomTextfield(
                controller: _cityController,
                hintText: "Enter city",
              ),
              verticalMargin16,
              Text(
                "Postal Code",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              CustomTextfield(
                controller: _postalCodeController,
                hintText: "Enter postal code",
              ),
              verticalMargin48,
              verticalMargin48,
              verticalMargin48,
              verticalMargin48,
              verticalMargin48,
                  ],
                ),
              ],
            );
          },
        ),
        bottomSheet: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            return Container(
              padding: horizontalPadding16,
              color: whiteColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientButton(
                    text: state is AccountUpdating ? "Saving..." : "Save Changes",
                    onTap: state is AccountUpdating ? null : _saveChanges,
                  ),
                  verticalMargin24,
                  GradientButton(
                    text: "Cancel",
                    onTap: () => context.pop(),
                    hideGradient: true,
                    backgroundColor: const Color(0XFFEBECED),
                    textStyle: context.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalMargin32,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
