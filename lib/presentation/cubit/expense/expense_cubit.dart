import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/services/transaction_service.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final TransactionService transactionService;

  StreamSubscription<List<TransactionModel>>? _subscription;
  List<TransactionModel> _expenses = [];
  String? _userId;

  ExpenseCubit({required this.transactionService}) : super(ExpenseInitial());

  void watchUserExpenses(String userId) {
    if (_userId == userId && _subscription != null) return;

    _userId = userId;
    emit(ExpenseLoading());
    _subscription?.cancel();
    _subscription = transactionService.watchTransactions(userId).listen(
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
      await transactionService.addTransaction(
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
      await transactionService.deleteTransaction(
        userId: userId,
        transactionId: expenseId,
      );
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
      await transactionService.updateTransaction(
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
