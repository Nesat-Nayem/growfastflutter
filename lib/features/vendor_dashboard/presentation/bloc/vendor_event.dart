import 'package:equatable/equatable.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';

abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object?> get props => [];
}

class LoadCountries extends VendorEvent {}

class LoadStates extends VendorEvent {
  final int countryId;
  const LoadStates(this.countryId);
}

class LoadCities extends VendorEvent {
  final int stateId;
  const LoadCities(this.stateId);
}

// New event for Step1 registration
class SubmitVendorStep1 extends VendorEvent {
  final VendorStep1Request request;
  const SubmitVendorStep1(this.request);
}
