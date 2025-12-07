import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// --- IMPORT WAJIB DARI FILE PENDUKUNG ---
import 'models/transaction.dart';
import 'screens/transactions_screen.dart'; 
import 'widgets/new_transaction_form.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Hive
  await Hive.initFlutter();
  
  // 2. Registrasi Adapter (Pastikan Anda sudah menjalankan build_runner!)
  Hive.registerAdapter(TransactionAdapter()); 
  
  // 3. Buka Box/Database untuk menyimpan data transaksi
  await Hive.openBox<Transaction>('transactions');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosKas App SIA',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key}); 

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  // Daftar halaman yang akan ditampilkan
  // Tidak perlu lagi mempassing data karena data diambil langsung dari Hive di dalam TransactionsScreen
  final List<Widget> _widgetOptions = <Widget>[
    const TransactionsScreen(), // Halaman Jurnal Transaksi
    const Center(child: Text('Halaman Pengaturan')), // Halaman Pengaturan sederhana
  ];

  // Fungsi untuk menampilkan NewTransactionForm (Modal)
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true, 
      builder: (_) {
        // Class ini diimport dari widgets/new_transaction_form.dart
        return const NewTransactionForm(); 
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KosKas - Pengelola Keuangan SIA'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Item pertama (Jurnal/Siklus Pengeluaran)
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Jurnal',
          ),
          // Item kedua (Pengaturan/Master Data)
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ], 
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
      // Tombol FAB untuk menambah transaksi baru
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}