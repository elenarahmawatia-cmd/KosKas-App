import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';

class TransactionService {
  final String _boxName = 'transactions';

  Future<Box<Transaction>> get _box async => await Hive.openBox<Transaction>(_boxName);

  Future<void> addTransaction(Transaction transaction) async {
    final box = await _box;
    await box.put(transaction.id, transaction); 
  }

  Stream<List<Transaction>> getTransactionsStream() {
    return Hive.box<Transaction>(_boxName).watch().map((_) {
      return Hive.box<Transaction>(_boxName).values.toList();
    });
  }

  Future<void> deleteTransaction(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}