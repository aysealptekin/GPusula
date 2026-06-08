import '../../../domain/transaction/entities/transaction.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<TransactionEntity> expenses;
  final bool isSaving;

  ExpenseLoaded({required this.expenses, this.isSaving = false});
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}
