import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction.dart';
import '../transaction_service.dart';

// Inisialisasi service untuk berinteraksi dengan Hive
final TransactionService _transactionService = TransactionService();

class NewTransactionForm extends StatefulWidget {
  const NewTransactionForm({super.key});

  @override
  State<NewTransactionForm> createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Makanan'; // Default category
  String _selectedPaymentMethod = 'Tunai'; // Default payment
  bool _isExpense = true; // True = Pengeluaran (Siklus Pengeluaran/Pembelian)

  // Daftar kategori dan metode pembayaran
  final List<String> _categories = ['Makanan', 'Transportasi', 'Bahan Baku', 'Gaji', 'Lainnya'];
  final List<String> _paymentMethods = ['Tunai', 'Bank Transfer', 'Kartu Debit'];


  // ===============================================================
  // 🛡️ IMPLEMENTASI PENGENDALIAN INTERNAL (Validasi dan Penyimpanan)
  // ===============================================================

  void _submitData() {
    // 1. Kontrol Validasi: Cek apakah form valid
    if (!_formKey.currentState!.validate()) {
      return; // Stop jika ada error validation
    }
    
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;
    
    // 2. Kontrol Validasi: Jumlah harus lebih dari nol
    if (enteredAmount <= 0) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah harus lebih dari Rp 0')),
      );
      return;
    }

    // Buat objek Transaksi baru
    final newTransaction = Transaction(
      id: const Uuid().v4(), // Menggunakan UUID sebagai ID unik
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate,
      category: _selectedCategory,
      isExpense: _isExpense,
      paymentMethod: _selectedPaymentMethod,
    );

    // Simpan ke Hive menggunakan TransactionService
    _transactionService.addTransaction(newTransaction);
    
    // Tutup modal setelah menyimpan
    Navigator.of(context).pop();
  }

  // Fungsi untuk memilih tanggal
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // Input Judul
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Judul / Keterangan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                // Input Jumlah
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final amount = double.tryParse(value ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Masukkan jumlah yang valid (> 0)';
                    }
                    return null;
                  },
                ),
                
                // Tipe Transaksi (Pemasukan / Pengeluaran)
                Row(
                  children: [
                    const Text('Tipe Transaksi:'),
                    Expanded(
                      child: SwitchListTile(
                        title: Text(_isExpense ? 'Pengeluaran' : 'Pemasukan',
                          style: TextStyle(color: _isExpense ? Colors.red : Colors.green)),
                        value: _isExpense,
                        onChanged: (val) {
                          setState(() {
                            _isExpense = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // Pilihan Kategori
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
                
                // Pilihan Metode Pembayaran (Relevansi SIA: Siklus Pembayaran/Pengeluaran)
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: const InputDecoration(labelText: 'Metode Pembayaran'),
                  items: _paymentMethods.map((String method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaymentMethod = newValue!;
                    });
                  },
                ),

                // Pemilihan Tanggal
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Tanggal: ${'${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'}',
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          'Pilih Tanggal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _presentDatePicker,
                      ),
                    ],
                  ),
                ),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan Transaksi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}