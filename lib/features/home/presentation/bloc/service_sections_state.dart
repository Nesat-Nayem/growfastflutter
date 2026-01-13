part of 'service_sections_bloc.dart';

class ServiceSectionsState extends Equatable {
  final bool isLoading;
  final List<ServiceSectionModel> featuredServices;
  final List<ServiceSectionModel> popularServices;
  final List<ServiceSectionModel> emergencyServices;
  final List<ServiceSectionModel> newlyOnboardedServices;
  final List<ServiceSectionModel> recommendedServices;
  final List<ServiceSectionModel> seasonalServices;

  const ServiceSectionsState({
    this.isLoading = false,
    this.featuredServices = const [],
    this.popularServices = const [],
    this.emergencyServices = const [],
    this.newlyOnboardedServices = const [],
    this.recommendedServices = const [],
    this.seasonalServices = const [],
  });

  ServiceSectionsState copyWith({
    bool? isLoading,
    List<ServiceSectionModel>? featuredServices,
    List<ServiceSectionModel>? popularServices,
    List<ServiceSectionModel>? emergencyServices,
    List<ServiceSectionModel>? newlyOnboardedServices,
    List<ServiceSectionModel>? recommendedServices,
    List<ServiceSectionModel>? seasonalServices,
  }) {
    return ServiceSectionsState(
      isLoading: isLoading ?? this.isLoading,
      featuredServices: featuredServices ?? this.featuredServices,
      popularServices: popularServices ?? this.popularServices,
      emergencyServices: emergencyServices ?? this.emergencyServices,
      newlyOnboardedServices:
          newlyOnboardedServices ?? this.newlyOnboardedServices,
      recommendedServices: recommendedServices ?? this.recommendedServices,
      seasonalServices: seasonalServices ?? this.seasonalServices,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        featuredServices,
        popularServices,
        emergencyServices,
        newlyOnboardedServices,
        recommendedServices,
        seasonalServices,
      ];
}
