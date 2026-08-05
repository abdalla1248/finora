import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../account/domain/entities/account.dart';
import '../../../budget/domain/entities/budget.dart';
import '../../../budget/domain/entities/savings_goal.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/services/backup_service.dart';
import 'backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  final BackupService _backupService;

  BackupCubit(this._backupService) : super(const BackupState());

  Future<void> exportToJson({
    required List<Transaction> transactions,
    required List<Budget> budgets,
    required List<SavingsGoal> goals,
    required List<Account> accounts,
  }) async {
    emit(state.copyWith(isExporting: true));
    try {
      final jsonPayload = _backupService.exportToJson(
        transactions: transactions,
        budgets: budgets,
        goals: goals,
        accounts: accounts,
      );
      final file = await _backupService.writeExportFile(
        'finora_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        jsonPayload,
      );
      emit(
        state.copyWith(
          isExporting: false,
          exportPayload: jsonPayload,
          statusMessage: file.path,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isExporting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> exportToCsv(List<Transaction> transactions) async {
    emit(state.copyWith(isExporting: true));
    try {
      final csvPayload = _backupService.exportToCsv(transactions);
      final file = await _backupService.writeExportFile(
        'finora_transactions_${DateTime.now().millisecondsSinceEpoch}.csv',
        csvPayload,
      );
      emit(
        state.copyWith(
          isExporting: false,
          exportPayload: csvPayload,
          statusMessage: file.path,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isExporting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> importFromJson(String jsonString) async {
    emit(state.copyWith(isImporting: true));
    try {
      final result = await _backupService.importAndRestoreFromJson(jsonString);
      final count = result['transactionsCount'];
      emit(
        state.copyWith(
          isImporting: false,
          statusMessage: 'Restored $count transactions from backup successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isImporting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> factoryReset() async {
    emit(state.copyWith(isExporting: true));
    try {
      await _backupService.factoryReset();
      emit(
        state.copyWith(
          isExporting: false,
          statusMessage: 'Factory reset completed!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isExporting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
