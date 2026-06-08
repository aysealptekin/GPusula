import '../../../data/models/transaction_model.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<TransactionModel> expenses;
  final bool isSaving;

  ExpenseLoaded({required this.expenses, this.isSaving = false});
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}
