import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/features/account/data/remote_datasource/account_remote_datasource.dart';
import 'package:grow_first/core/app_store/app_store.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRemoteDataSource remoteDataSource;
  final AppStore appStore;

  AccountCubit(this.remoteDataSource, this.appStore) : super(AccountInitial());

  Future<void> loadProfile() async {
    emit(AccountLoading());
    try {
      final response = await remoteDataSource.getProfile();
      if (response['status'] == 'success') {
        emit(AccountLoaded(response['user']));
      } else {
        emit(AccountError(response['message'] ?? 'Failed to load profile'));
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(AccountUpdating());
    try {
      final response = await remoteDataSource.updateProfile(data);
      if (response['status'] == 'success') {
        // Update AppStore with new user data
        final updatedUser = response['user'];
        await appStore.updateUser(updatedUser);
        emit(AccountUpdateSuccess(updatedUser));
      } else {
        emit(AccountError(response['message'] ?? 'Failed to update profile'));
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> updateProfileWithImage(Map<String, dynamic> data, File image) async {
    emit(AccountUpdating());
    try {
      final response = await remoteDataSource.updateProfileWithImage(data, image);
      if (response['status'] == 'success') {
        // Update AppStore with new user data
        final updatedUser = response['user'];
        await appStore.updateUser(updatedUser);
        emit(AccountUpdateSuccess(updatedUser));
      } else {
        emit(AccountError(response['message'] ?? 'Failed to update profile'));
      }
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
