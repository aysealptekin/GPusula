import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    return repository.addExpense(
      userId: userId,
      title: title,
      amount: amount,
      category: category,
      type: type,
    );
  }
}
