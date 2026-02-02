import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';

import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_state.dart';
import 'package:grow_first/features/auth/presentation/widgets/mobile_number_filed_widget.dart';
import 'package:grow_first/features/home/di/injections.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_bloc.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_event.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_state.dart';
import 'package:grow_first/features/widgets/custom_text_field.dart';

class VendorDashboardPage extends StatefulWidget {
  const VendorDashboardPage({super.key});

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final websiteController = TextEditingController();
  final gstNocontroller = TextEditingController();
  final postalCodeController = TextEditingController();
  final localityController = TextEditingController();
  final subLocalityController = TextEditingController();
  final detailAddressController = TextEditingController();
  final nameOfServiceController = TextEditingController();

  String? selectedGender = 'Male';
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  int? selectedCountryId;
  int? selectedStateId;
  bool isMobileValid = false;

  @override
  void initState() {
    super.initState();
    // Reset vendor registration state to clear any stale data from previous sessions
    sl<VendorBloc>().add(ResetVendorRegistration());
    // Then load countries
    Future.microtask(() => sl<VendorBloc>().add(LoadCountries()));
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
    localityController.dispose();
    subLocalityController.dispose();
    detailAddressController.dispose();
    nameOfServiceController.dispose();
    super.dispose();
  }

  void _submitStep1() {
    if (!_formKey.currentState!.validate()) return;

    final request = VendorStep1Request(
      fullName: fullNameController.text.trim(),
      companyName: companyNameController.text.trim(),
      email: emailController.text.trim(),
      phone: mobileController.text.trim(),
      gender: selectedGender ?? 'Male',
      website: websiteController.text.trim().isEmpty ? null : websiteController.text.trim(),
      gst: gstNocontroller.text.trim().isEmpty ? null : gstNocontroller.text.trim(),
      country: selectedCountryId?.toString() ?? '',
      state: selectedStateId?.toString() ?? '',
      city: selectedCity ?? '',
      locality: localityController.text.trim(),
      subLocality: subLocalityController.text.trim(),
      pincode: postalCodeController.text.trim(),
      detailAddress: detailAddressController.text.trim(),
      nameOfService: nameOfServiceController.text.trim(),
    );

    sl<VendorBloc>().add(SubmitVendorStep1(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Become a vendor", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<VendorBloc, VendorState>(
        bloc: sl<VendorBloc>(),
        listenWhen: (previous, current) {
          return (previous.step1Success != current.step1Success) ||
                 (previous.step1Error != current.step1Error);
        },
        listener: (context, state) {
          if (state.step1Success) {
            context.pushNamed(AppRouterNames.vendorKycForm);
          }
          if (state.step1Error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.step1Error!), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading..."),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step Progress Header
                        _buildStepHeader(),
                        const SizedBox(height: 16),
                        
                        // Full Name
                        _buildLabel("Full Name *"),
                        _buildTextInput(fullNameController, "Enter full name", required: true),
                        
                        // Company Name
                        _buildLabel("Company Name *"),
                        _buildTextInput(companyNameController, "Enter company name", required: true),
                        
                        // Email
                        _buildLabel("Email *"),
                        _buildTextInput(emailController, "Enter email", required: true, isEmail: true),
                        
                        // Mobile Number
                        _buildLabel("Mobile Number *"),
                        _buildMobileInput(),
                        
                        // Name of Service
                        _buildLabel("Name of Service *"),
                        _buildTextInput(nameOfServiceController, "e.g. Plumbing, Cleaning", required: true),
                        
                        // Gender
                        _buildLabel("Gender"),
                        _buildGenderDropdown(),
                        
                        // Website
                        _buildLabel("Website (Optional)"),
                        _buildTextInput(websiteController, "www.yourwebsite.com"),
                        
                        // GST No
                        _buildLabel("GST No. (Optional)"),
                        _buildTextInput(gstNocontroller, "Enter your GSTIN"),
                        
                        // Country & State Row
                        Row(
                          children: [
                            Expanded(child: _buildCountryDropdown(state)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildStateDropdown(state)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // City
                        _buildCityDropdown(state),
                        const SizedBox(height: 16),
                        
                        // Locality
                        _buildLabel("Locality (Optional)"),
                        _buildTextInput(localityController, "Enter locality"),
                        
                        // Sub Locality
                        _buildLabel("Sub Locality (Optional)"),
                        _buildTextInput(subLocalityController, "Enter sub locality"),
                        
                        // Postal Code
                        _buildLabel("Postal Code (Optional)"),
                        _buildTextInput(postalCodeController, "Enter postal code"),
                        
                        // Detail Address
                        _buildLabel("Detail Address *"),
                        _buildTextInput(detailAddressController, "Enter full address", required: true),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              // Next Button at bottom
              SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: state.isSubmittingStep1 ? null : _submitStep1,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10326B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      state.isSubmittingStep1 ? "Submitting..." : "Next",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepHeader() {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStep(Icons.info_outline, "Basic Info", isActive: true),
            _buildStepLine(),
            _buildStep(Icons.cast_outlined, "Choose Plan"),
            _buildStepLine(),
            _buildStep(Icons.description_outlined, "KYC Details"),
            _buildStepLine(),
            _buildStep(Icons.check, "Confirmation"),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(IconData icon, String label, {bool isActive = false, bool isCompleted = false}) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? const LinearGradient(colors: [Color(0xFF10326B), Color(0xFF30D3D9)])
                : null,
            color: isCompleted ? const Color(0xFF30D3D9) : (isActive ? null : Colors.white),
            border: Border.all(
              color: isActive || isCompleted ? Colors.transparent : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Icon(icon, size: 22, color: isActive || isCompleted ? Colors.white : Colors.grey.shade500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
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
  }

  Widget _buildStepLine() {
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.only(top: 24),
      color: Colors.grey.shade300,
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: context.labelMedium),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String hint, {bool required = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomTextField(
        controller: controller,
        hintText: hint,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) return "This field is required";
                if (isEmail && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value.trim())) {
                  return "Enter a valid email";
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildMobileInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BlocBuilder<CountryCubit, CountryState>(
        bloc: sl<CountryCubit>(),
        builder: (context, state) {
          if (state is CountryLoaded) {
            final defaultCountry = state.countries.firstWhere(
              (e) => e.code == PlatformDispatcher.instance.locale.countryCode,
              orElse: () => state.countries.first,
            );
            return MobileNumberField(
              controller: mobileController,
              initialCountryCode: defaultCountry.code,
              initialFlagAsset: defaultCountry.flag,
              onValidChanged: (isValid) => setState(() => isMobileValid = isValid),
            );
          }
          return CustomTextField(
            controller: mobileController,
            hintText: "Mobile Number",
            keyboardType: TextInputType.phone,
            validator: (v) => v?.isEmpty == true ? "Required" : null,
          );
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        dropdownColor: whiteColor,
        value: selectedGender,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: InputDecoration(
          hintText: "Select Gender",
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: lightGreyColor, width: 1),
          ),
        ),
        items: ["Male", "Female", "Other"]
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: (v) => setState(() => selectedGender = v),
      ),
    );
  }

  Widget _buildCountryDropdown(VendorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Country"),
        DropdownButtonFormField<String>(
          value: selectedCountry,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            hintText: "Select Country",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          items: state.countries
              .map((c) => DropdownMenuItem<String>(
                    value: c.name,
                    child: Text(c.name, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (value) {
            if (value == null || state.countries.isEmpty) return;
            final country = state.countries.firstWhere((c) => c.name == value);
            setState(() {
              selectedCountry = value;
              selectedCountryId = country.id;
              selectedState = null;
              selectedStateId = null;
              selectedCity = null;
            });
            sl<VendorBloc>().add(LoadStates(country.id));
          },
        ),
      ],
    );
  }

  Widget _buildStateDropdown(VendorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("State"),
        DropdownButtonFormField<String>(
          value: selectedState,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            hintText: state.isStatesLoading ? "Loading..." : "Select State",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          items: state.states
              .map((s) => DropdownMenuItem<String>(
                    value: s.name,
                    child: Text(s.name, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (value) {
            if (value == null || state.states.isEmpty) return;
            final st = state.states.firstWhere((s) => s.name == value);
            setState(() {
              selectedState = value;
              selectedStateId = st.id;
              selectedCity = null;
            });
            sl<VendorBloc>().add(LoadCities(st.id));
          },
        ),
      ],
    );
  }

  Widget _buildCityDropdown(VendorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("City"),
        DropdownButtonFormField<String>(
          value: selectedCity,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            hintText: state.isCitiesLoading ? "Loading..." : "Select City",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          items: state.cities
              .map((city) => DropdownMenuItem<String>(
                    value: city.name,
                    child: Text(city.name, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (value) => setState(() => selectedCity = value),
        ),
      ],
    );
  }
}

// Keep these for other pages that import them
class StepProgressHeader extends StatelessWidget {
  final int currentStep;
  final List<StepItem> steps;

  const StepProgressHeader({super.key, required this.currentStep, required this.steps});

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
              return Container(width: 20, margin: const EdgeInsets.only(top: 24), height: 2, color: Colors.grey.shade300);
            }
            final stepIndex = index ~/ 2;
            final step = steps[stepIndex];
            final isActive = stepIndex == currentStep;
            final isCompleted = stepIndex < currentStep;

            return Column(
              children: [
                _StepCircle(icon: step.icon, isActive: isActive, isCompleted: isCompleted),
                const SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  child: Text(step.label, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500, color: isActive ? Colors.black : Colors.grey.shade600)),
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

  const _StepCircle({required this.icon, required this.isActive, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isActive ? const LinearGradient(colors: [Color(0xFF10326B), Color(0xFF30D3D9)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
        color: isCompleted ? const Color(0xFF30D3D9) : Colors.white,
        border: Border.all(color: isActive || isCompleted ? Colors.transparent : Colors.grey.shade300, width: 2),
      ),
      child: Icon(icon, size: 22, color: isActive || isCompleted ? Colors.white : Colors.grey.shade500),
    );
  }
}

class StepItem {
  final String label;
  final IconData icon;
  const StepItem({required this.label, required this.icon});
}
