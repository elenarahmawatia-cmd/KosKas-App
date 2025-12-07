import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../transaction_service.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = TransactionService(); 

    return StreamBuilder<List<Transaction>>(
      stream: service.getTransactionsStream(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return const Center(
            child: Text('Belum ada transaksi!'),
          );
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
                title: Text(transaction.title),
                trailing: Text('Rp ${transaction.amount.toStringAsFixed(2)}'),
            );
          },
        );
      },
    );
  }
}