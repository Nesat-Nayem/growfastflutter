import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_state.dart';
import 'package:grow_first/features/auth/presentation/widgets/mobile_number_filed_widget.dart';
import 'package:grow_first/features/home/di/injections.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_bloc.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_event.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_state.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_text_field.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';


class VendorDashboardPage extends StatefulWidget {
  const VendorDashboardPage({super.key});

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController gstNocontroller = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  // Dropdown selections
  String? selectedGender = 'Male';
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  bool isMobileValid = false;

  @override
  void initState() {
    super.initState();
    // Load countries when page initializes
    sl<VendorBloc>().add(LoadCountries());
  }

  @override
  void dispose() {
    fullNameController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    websiteController.dispose();
    gstNocontroller.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Become a vendor"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StepProgressHeader(
                currentStep: 0,
                steps: const [
                  StepItem(label: "Basic Info", icon: Icons.info_outline),
                  StepItem(label: "Choose Plan", icon: Icons.cast_outlined),
                  StepItem(
                    label: "KYC Details",
                    icon: Icons.description_outlined,
                  ),
                  StepItem(label: "Confirmation", icon: Icons.check),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalMargin16,
                      // Full Name
                      Text("Full Name", style: context.labelMedium),
                      verticalMargin8,
                      CustomTextField(
                        controller: fullNameController,
                        hintText: "Full Name",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Full Name is required";
                          }
                          return null;
                        },
                      ),
                      verticalMargin16,

                      // Company Name
                      Text("Company Name", style: context.labelMedium),
                      verticalMargin8,
                      CustomTextField(
                        controller: companyNameController,
                        hintText: "Company Name",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Company Name is required";
                          }
                          return null;
                        },
                      ),
                      verticalMargin16,

                      // Email
                      Text("Email", style: context.labelMedium),
                      verticalMargin8,
                      CustomTextField(
                        controller: emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }
                          final emailRegex = RegExp(
                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      verticalMargin16,

                      // Mobile Number
                      Text("Mobile Number", style: context.labelMedium),
                      verticalMargin8,
                      BlocBuilder<CountryCubit, CountryState>(
                        bloc: sl<CountryCubit>(),
                        builder: (context, state) {
                          if (state is CountryLoaded) {
                            return MobileNumberField(
                              controller: mobileController,
                              initialCountryCode: state.countries
                                  .firstWhere(
                                    (e) =>
                                        e.code ==
                                        PlatformDispatcher
                                            .instance
                                            .locale
                                            .countryCode,
                                  )
                                  .code,
                              initialFlagAsset: state.countries
                                  .firstWhere(
                                    (e) =>
                                        e.code ==
                                        PlatformDispatcher
                                            .instance
                                            .locale
                                            .countryCode,
                                  )
                                  .flag,
                              onValidChanged: (isValid) {
                                setState(() {
                                  isMobileValid = isValid;
                                });
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      GenderDropdownField(
                        value: selectedGender,
                        onChanged: (value) {
                          setState(() => selectedGender = value);
                        },
                      ),
                      if (selectedGender == null)
                        Text(
                          "Gender is required",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      verticalMargin16,

                      // Website
                      Text("Website (Optional)", style: context.labelMedium),
                      verticalMargin8,
                      CustomTextField(
                        controller: websiteController,
                        hintText: "www.yourwebsitedomain.com",
                        keyboardType: TextInputType.text,
                      ),
                      verticalMargin16,

                      // GST No
                      Text("GST No. (Optional)", style: context.labelMedium),
                      verticalMargin8,
                      CustomTextField(
                        controller: gstNocontroller,
                        hintText: "Enter your GSTIN",
                        keyboardType: TextInputType.text,
                      ),
                      verticalMargin16,

                      // Country & State Row
                      CountryStateRow(
                        onCountryChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                            selectedState = null;
                            selectedCity = null;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            selectedState = value;
                            selectedCity = null;
                          });
                        },
                        selectedCountry: selectedCountry,
                        selectedState: selectedState,
                      ),
                      if (selectedCountry == null)
                        Text(
                          "Country is required",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      if (selectedState == null)
                        Text(
                          "State is required",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      verticalMargin16,

                      // City
                      BlocBuilder<VendorBloc, VendorState>(
                        bloc: sl<VendorBloc>(),
                        builder: (context, state) {
                          return CustomDropdownField<String>(
                            label: "City",
                            hint: "Select City",
                            value: selectedCity,
                            onChanged: (value) {
                              setState(() => selectedCity = value);
                            },
                            items: state.cities.map((city) {
                              return DropdownMenuItem<String>(
                                value: city.name,
                                child: Text(city.name),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      if (selectedCity == null)
                        Text(
                          "City is required",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      verticalMargin16,

                      // Postal Code
                      Text("Postal Code", style: context.labelMedium),
                      verticalMargin8,
                      CustomTextField(
                        controller: postalCodeController,
                        hintText: "Enter your postal code",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Postal Code is required";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                      ),
                      verticalMargin16,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: bottomPadding12 + horizontalPadding16,
          child: Column(
            mainAxisAlignment: .end,
            mainAxisSize: .min,
            children: [
              BlocListener<VendorBloc, VendorState>(
                bloc: sl<VendorBloc>(),
                listener: (context, state) {
                  if (state.step1Success) {
                    context.pushNamed(AppRouterNames.vendorChoosePlan);
                  }
                },
                child: GradientButton(
                  text: "Next",
                  onTap: () {
                    if (_formKey.currentState!.validate() &&
                        selectedGender != null &&
                        selectedCountry != null &&
                        selectedState != null &&
                        selectedCity != null) {
                      // Navigate to next step directly
                      context.pushNamed(AppRouterNames.vendorChoosePlan);
                    } else {
                      // show error
                      setState(() {});
                    }
                  },
                  textStyle: context.labelLarge.copyWith(color: whiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepProgressHeader extends StatelessWidget {
  final int currentStep;
  final List<StepItem> steps;

  const StepProgressHeader({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector line
              return Container(
                width: 20,
                margin: const EdgeInsets.only(top: 24),
                height: 2,
                color: Colors.grey.shade300,
              );
            }

            final stepIndex = index ~/ 2;
            final step = steps[stepIndex];
            final isActive = stepIndex == currentStep;
            final isCompleted = stepIndex < currentStep;

            return Column(
              children: [
                _StepCircle(
                  icon: step.icon,
                  isActive: isActive,
                  isCompleted: isCompleted,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    step.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isCompleted;

  const _StepCircle({
    required this.icon,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFF10326B), Color(0xFF30D3D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isCompleted ? const Color(0xFF30D3D9) : Colors.white,
        border: Border.all(
          color: isActive || isCompleted
              ? Colors.transparent
              : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: 22,
        color: isActive || isCompleted ? Colors.white : Colors.grey.shade500,
      ),
    );
  }
}

class StepItem {
  final String label;
  final IconData icon;

  const StepItem({required this.label, required this.icon});
}

class GenderDropdownField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const GenderDropdownField({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: context.labelMedium.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: whiteColor,
          initialValue: value,
          icon: Padding(
            padding: horizontalPadding12,
            child: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
          decoration: InputDecoration(
            hintText: "Select Gender",
            hintStyle: context.labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
            contentPadding: verticalPadding8 + horizontalPadding8,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: lightGreyColor, width: 1),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: "Male",
              child: Text(
                "Male",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            DropdownMenuItem(
              value: "Female",
              child: Text(
                "Female",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            DropdownMenuItem(
              value: "Other",
              child: Text(
                "Other",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: context.labelMedium.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CountryStateRow extends StatelessWidget {
  final String? selectedCountry;
  final String? selectedState;
  final ValueChanged<String?>? onCountryChanged;
  final ValueChanged<String?>? onStateChanged;

  const CountryStateRow({
    super.key,
    this.selectedCountry,
    this.selectedState,
    this.onCountryChanged,
    this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // COUNTRY
        BlocBuilder<VendorBloc, VendorState>(
          bloc: sl<VendorBloc>(),
          builder: (context, state) {
            return Expanded(
              child: CustomDropdownField<String>(
                label: "Country",
                hint: "Select Country",
                value:
                    selectedCountry ??
                    (state.countries.isNotEmpty
                        ? state.countries.first.name
                        : null),
                onChanged: (value) {
                  if (onCountryChanged != null) {
                    onCountryChanged!(value);
                  }
                  sl<VendorBloc>().add(
                    LoadStates(
                      state.countries
                          .firstWhere((country) => country.name == value)
                          .id,
                    ),
                  );
                },
                items: state.countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country.name,
                    child: Text(
                      country.name,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),

        const SizedBox(width: 12),

        // STATE
        BlocBuilder<VendorBloc, VendorState>(
          bloc: sl<VendorBloc>(),
          builder: (context, state) {
            return Expanded(
              child: CustomDropdownField<String>(
                label: "State",
                hint: "Select State",
                value:
                    selectedState ??
                    (state.states.isNotEmpty ? state.states.first.name : null),
                onChanged: (value) {
                  if (onStateChanged != null) {
                    onStateChanged!(value);
                  }
                  sl<VendorBloc>().add(
                    LoadCities(
                      state.states
                          .firstWhere((state) => state.name == value)
                          .id,
                    ),
                  );
                },
                items: state.states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state.name,
                    child: Text(
                      state.name,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
