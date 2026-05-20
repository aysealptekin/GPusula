import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Stream<List<ExpenseModel>> watchExpenses(String userId);

  Future<void> addExpense({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  });
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExpenseRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _expensesRef(String userId) {
    return firestore.collection('users').doc(userId).collection('expenses');
  }

  @override
  Stream<List<ExpenseModel>> watchExpenses(String userId) {
    return _expensesRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(ExpenseModel.fromFirestore).toList(),
        );
  }

  @override
  Future<void> addExpense({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    final expense = ExpenseModel(
      id: '',
      title: title,
      amount: amount,
      category: category,
      type: type,
      createdAt: DateTime.now(),
    );

    return _expensesRef(userId).add(expense.toFirestore());
  }
}
