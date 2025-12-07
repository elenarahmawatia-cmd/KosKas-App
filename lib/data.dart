// File: lib/data.dart

import 'models/transaction.dart'; // Import cetakan Transaction

// Daftar transaksi sementara Anda (sebagai contoh data awal)
List<Transaction> userTransactions = [
  Transaction(
    id: 't1',
    title: 'Uang Kiriman Ortu',
    amount: 3000000.0,
    date: DateTime.now().subtract(const Duration(days: 3)),
    category: 'Pemasukan',
    isExpense: false,
    paymentMethod: 'Bank',
  ),
  Transaction(
    id: 't2',
    title: 'Beli Makan Siang',
    amount: 35000.0,
    date: DateTime.now().subtract(const Duration(days: 1)),
    category: 'Makanan',
    isExpense: true,
    paymentMethod: 'Tunai',
  ),
];