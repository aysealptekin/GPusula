import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/expense/entities/expense.dart';
import '../../../domain/expense/usecases/add_expense_usecase.dart';
import '../../../domain/expense/usecases/watch_expenses_usecase.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final WatchExpensesUseCase watchExpensesUseCase;
  final AddExpenseUseCase addExpenseUseCase;

  StreamSubscription<List<Expense>>? _subscription;
  List<Expense> _expenses = [];
  String? _userId;

  ExpenseCubit({
    required this.watchExpensesUseCase,
    required this.addExpenseUseCase,
  }) : super(ExpenseInitial());

  void watchUserExpenses(String userId) {
    if (_userId == userId && _subscription != null) return;

    _userId = userId;
    emit(ExpenseLoading());
    _subscription?.cancel();
    _subscription = watchExpensesUseCase(userId).listen(
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
      await addExpenseUseCase(
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
