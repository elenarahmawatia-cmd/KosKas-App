import 'package:hive_flutter/hive_flutter.dart';
part 'transaction.g.dart';

@HiveType(typeId: 0) 
class Transaction {
  
  @HiveField(0) 
  final String id; 
  
  @HiveField(1)
  final String title; 
  
  @HiveField(2)
  final double amount; 
  
  @HiveField(3)
  final DateTime date; 
  
  @HiveField(4)
  final String category; 
  
  @HiveField(5)
  final bool isExpense; // True jika Pengeluaran, False jika Pemasukan
  
  @HiveField(6)
  final String paymentMethod; 

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isExpense,
    required this.paymentMethod,
  });
}