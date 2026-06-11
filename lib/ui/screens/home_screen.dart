import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/finance_inherited_widget.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FinanceProvider.of(context).loadData();
    });
  }

  final List<String> _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  String _formatMonth(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final financeState = FinanceProvider.of(context);

    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(financeState),
            Expanded(
              child: _buildTransactionList(financeState),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        backgroundColor: Color(0xFF3F51B5),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('İşlem Ekle', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(financeState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.grey[800]),
                onPressed: () => financeState.changeMonth(-1),
              ),
              ValueListenableBuilder<DateTime>(
                valueListenable: financeState.selectedMonth,
                builder: (context, date, child) {
                  return Text(
                    _formatMonth(date),
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.grey[800]),
                onPressed: () => financeState.changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: 16),
          ValueListenableBuilder<double>(
            valueListenable: financeState.toplamBakiye,
            builder: (context, bakiye, child) {
              return ValueListenableBuilder<double>(
                valueListenable: financeState.totalGelirler,
                builder: (context, gelir, child) {
                  return ValueListenableBuilder<double>(
                    valueListenable: financeState.totalGiderler,
                    builder: (context, gider, child) {
                      return BalanceCard(
                        bakiye: bakiye,
                        gelir: gelir,
                        gider: gider,
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(financeState) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: financeState.transactionsNotifier,
      builder: (context, transactions, child) {
        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey[300]),
                SizedBox(height: 16),
                Text(
                  'Henüz işlem bulunmuyor',
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 80),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final t = transactions[index];
            return TransactionTile(
              transaction: t,
              onDelete: () => financeState.deleteTransaction(t['id']),
            );
          },
        );
      },
    );
  }
}
