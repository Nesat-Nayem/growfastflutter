import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/features/home/data/model/service_section_model.dart';
import 'package:grow_first/features/home/domain/usecases/get_services_by_type_usecase.dart';

part 'service_sections_event.dart';
part 'service_sections_state.dart';

class ServiceSectionsBloc
    extends Bloc<ServiceSectionsEvent, ServiceSectionsState> {
  final GetServicesByTypeUseCase getServicesByTypeUseCase;

  ServiceSectionsBloc(this.getServicesByTypeUseCase)
      : super(const ServiceSectionsState()) {
    on<LoadAllServiceSections>(_onLoadAllServiceSections);
  }

  Future<void> _onLoadAllServiceSections(
    LoadAllServiceSections event,
    Emitter<ServiceSectionsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final serviceTypes = [
      'featured',
      'popular',
      'emergency',
      'newly_onboarded',
      'recommended',
      'seasonal',
    ];

    final Map<String, List<ServiceSectionModel>> sections = {};

    for (final type in serviceTypes) {
      final result =
          await getServicesByTypeUseCase(ServiceTypeParams(serviceType: type));
      result.fold(
        (failure) {
          debugPrint("❌ Failed to load $type services");
          sections[type] = [];
        },
        (services) {
          debugPrint("✅ Loaded ${services.length} $type services");
          sections[type] = services;
        },
      );
    }

    emit(state.copyWith(
      isLoading: false,
      featuredServices: sections['featured'] ?? [],
      popularServices: sections['popular'] ?? [],
      emergencyServices: sections['emergency'] ?? [],
      newlyOnboardedServices: sections['newly_onboarded'] ?? [],
      recommendedServices: sections['recommended'] ?? [],
      seasonalServices: sections['seasonal'] ?? [],
    ));
  }
}
