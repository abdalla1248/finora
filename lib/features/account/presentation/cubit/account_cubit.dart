import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;

  AccountCubit(this._accountRepository) : super(const AccountState());

  Future<void> loadAccounts() async {
    emit(state.copyWith(isLoading: true));
    final result = await _accountRepository.getAccounts();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (accounts) => emit(state.copyWith(accounts: accounts, isLoading: false)),
    );
  }

  Future<void> addAccount(Account account) async {
    emit(state.copyWith(isLoading: true));
    if (account.isDefault) {
      for (final a in state.accounts) {
        if (a.id != account.id && a.isDefault) {
          await _accountRepository.saveAccount(a.copyWith(isDefault: false));
        }
      }
    }
    final result = await _accountRepository.saveAccount(account);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadAccounts(),
    );
  }

  Future<void> deleteAccount(String id) async {
    emit(state.copyWith(isLoading: true));
    final result = await _accountRepository.deleteAccount(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => loadAccounts(),
    );
  }
}
