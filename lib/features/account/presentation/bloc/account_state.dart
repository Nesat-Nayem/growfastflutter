part of 'account_cubit.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final Map<String, dynamic> user;
  AccountLoaded(this.user);
}

class AccountUpdating extends AccountState {}

class AccountUpdateSuccess extends AccountState {
  final Map<String, dynamic> user;
  AccountUpdateSuccess(this.user);
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}
