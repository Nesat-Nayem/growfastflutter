import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/features/customer_home/data/remote_datasource/dashboard_remote_datasource.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardCubit(this.remoteDataSource) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final response = await remoteDataSource.getDashboardData();
      if (response['status'] == true) {
        emit(DashboardLoaded(response['data']));
      } else {
        emit(DashboardError(response['message'] ?? 'Failed to load dashboard'));
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        emit(DashboardUnauthorized());
      } else if (e.toString().contains('401')) {
        emit(DashboardUnauthorized());
      } else {
        emit(DashboardError(e.toString()));
      }
    }
  }
}
