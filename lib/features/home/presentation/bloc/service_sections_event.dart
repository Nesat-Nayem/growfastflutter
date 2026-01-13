part of 'service_sections_bloc.dart';

abstract class ServiceSectionsEvent extends Equatable {
  const ServiceSectionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllServiceSections extends ServiceSectionsEvent {
  const LoadAllServiceSections();
}
