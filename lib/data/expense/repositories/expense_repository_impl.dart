import '../../../domain/expense/entities/expense.dart';
import '../../../domain/expense/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Expense>> watchExpenses(String userId) {
    return remoteDataSource.watchExpenses(userId);
  }

  @override
  Future<void> addExpense({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    return remoteDataSource.addExpense(
      userId: userId,
      title: title,
      amount: amount,
      category: category,
      type: type,
    );
  }
}
