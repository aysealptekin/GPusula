import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class WatchExpensesUseCase {
  final ExpenseRepository repository;

  WatchExpensesUseCase(this.repository);

  Stream<List<Expense>> call(String userId) {
    return repository.watchExpenses(userId);
  }
}
