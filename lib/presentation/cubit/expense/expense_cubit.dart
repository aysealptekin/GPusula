import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/transaction/entities/transaction.dart';
import '../../../domain/transaction/usecases/add_transaction_usecase.dart';
import '../../../domain/transaction/usecases/delete_transaction_usecase.dart';
import '../../../domain/transaction/usecases/reset_vibe_statuses_usecase.dart';
import '../../../domain/transaction/usecases/update_transaction_usecase.dart';
import '../../../domain/transaction/usecases/update_vibe_status_usecase.dart';
import '../../../domain/transaction/usecases/watch_transactions_usecase.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final WatchTransactionsUseCase watchTransactionsUseCase;
  final AddTransactionUseCase addTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final UpdateVibeStatusUseCase updateVibeStatusUseCase;
  final ResetVibeStatusesUseCase resetVibeStatusesUseCase;

  StreamSubscription<List<TransactionEntity>>? _subscription;
  List<TransactionEntity> _expenses = [];
  String? _userId;

  ExpenseCubit({
    required this.watchTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.updateVibeStatusUseCase,
    required this.resetVibeStatusesUseCase,
  }) : super(ExpenseInitial());

  void watchUserExpenses(String userId) {
    if (_userId == userId && _subscription != null) return;

    _userId = userId;
    emit(ExpenseLoading());
    _subscription?.cancel();
    _subscription = watchTransactionsUseCase(userId).listen(
      (expenses) {
        _expenses = expenses;
        emit(ExpenseLoaded(expenses: expenses));
      },
      onError: (error) {
        emit(ExpenseError(error.toString()));
      },
    );
  }

  Future<bool> addExpense({
    required String title,
    required double amount,
    required String category,
    required String type,
  }) async {
    final userId = _userId;
    if (userId == null) {
      emit(ExpenseError('Harcama eklemek icin giris yapmalisin'));
      return false;
    }

    emit(ExpenseLoaded(expenses: _expenses, isSaving: true));

    try {
      await addTransactionUseCase(
        userId: userId,
        title: title,
        amount: amount,
        category: category,
        type: type,
      );
      return true;
    } catch (error) {
      emit(ExpenseError(error.toString()));
      emit(ExpenseLoaded(expenses: _expenses));
      return false;
    }
  }

  Future<bool> deleteExpense(String expenseId) async {
    final userId = _userId;
    if (userId == null) {
      emit(ExpenseError('Islem silmek icin giris yapmalisin'));
      return false;
    }

    try {
      await deleteTransactionUseCase(userId: userId, transactionId: expenseId);
      return true;
    } catch (error) {
      emit(ExpenseError(error.toString()));
      emit(ExpenseLoaded(expenses: _expenses));
      return false;
    }
  }

  Future<bool> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) async {
    final userId = _userId;
    if (userId == null) {
      emit(ExpenseError('Islem duzenlemek icin giris yapmalisin'));
      return false;
    }

    emit(ExpenseLoaded(expenses: _expenses, isSaving: true));

    try {
      await updateTransactionUseCase(
        userId: userId,
        transactionId: expenseId,
        title: title,
        amount: amount,
        category: category,
        type: type,
      );
      return true;
    } catch (error) {
      emit(ExpenseError(error.toString()));
      emit(ExpenseLoaded(expenses: _expenses));
      return false;
    }
  }

  Future<bool> markVibeStatus({
    required String expenseId,
    required String vibeStatus,
  }) async {
    final userId = _userId;
    if (userId == null) {
      emit(ExpenseError('Vibe değerlendirmesi için giriş yapmalısın'));
      return false;
    }

    try {
      await updateVibeStatusUseCase(
        userId: userId,
        transactionId: expenseId,
        vibeStatus: vibeStatus,
      );
      return true;
    } catch (error) {
      emit(ExpenseError(error.toString()));
      emit(ExpenseLoaded(expenses: _expenses));
      return false;
    }
  }

  Future<bool> resetVibeHistory() async {
    final userId = _userId;
    if (userId == null) {
      emit(ExpenseError('Vibe geçmişini sıfırlamak için giriş yapmalısın'));
      return false;
    }

    try {
      await resetVibeStatusesUseCase(userId);
      return true;
    } catch (error) {
      emit(ExpenseError(error.toString()));
      emit(ExpenseLoaded(expenses: _expenses));
      return false;
    }
  }

  void clear() {
    _subscription?.cancel();
    _subscription = null;
    _expenses = [];
    _userId = null;
    emit(ExpenseInitial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
