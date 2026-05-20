import '../entities/expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchExpenses(String userId);

  Future<void> addExpense({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  });
}
