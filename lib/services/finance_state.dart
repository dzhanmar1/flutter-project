import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class FinanceState {
  final ValueNotifier<List<Map<String, dynamic>>> transactionsNotifier = ValueNotifier([]);
  final ValueNotifier<List<FinanceCategory>> categoriesNotifier = ValueNotifier([]);
  
  final ValueNotifier<double> totalGelirler = ValueNotifier(0.0);
  final ValueNotifier<double> totalGiderler = ValueNotifier(0.0);
  final ValueNotifier<double> toplamBakiye = ValueNotifier(0.0);

  // Statistics map: Category Name -> Total Amount
  final ValueNotifier<Map<String, double>> categoryExpenses = ValueNotifier({});

  final ValueNotifier<DateTime> selectedMonth = ValueNotifier(DateTime.now());
  List<Map<String, dynamic>> _allTransactions = [];

  FinanceState() {
    selectedMonth.addListener(() {
      _filterTransactions();
    });
  }

  Future<void> loadData() async {
    await loadCategories();
    await loadTransactions();
  }

  Future<void> loadCategories() async {
    final categories = await DatabaseHelper.instance.getCategories();
    categoriesNotifier.value = categories;
  }

  Future<void> loadTransactions() async {
    _allTransactions = await DatabaseHelper.instance.getTransactionsWithCategory();
    _filterTransactions();
  }

  void _filterTransactions() {
    final month = selectedMonth.value;
    final filtered = _allTransactions.where((t) {
      DateTime date = DateTime.parse(t['date']);
      return date.month == month.month && date.year == month.year;
    }).toList();
    
    transactionsNotifier.value = filtered;
    _calculateTotals(filtered);
  }

  void changeMonth(int offset) {
    final current = selectedMonth.value;
    selectedMonth.value = DateTime(current.year, current.month + offset, 1);
  }

  void _calculateTotals(List<Map<String, dynamic>> transactions) {
    double gelir = 0;
    double gider = 0;
    Map<String, double> expensesMap = {};

    for (var t in transactions) {
      double amount = t['amount'];
      if (t['category_type'] == 1) {
        gelir += amount;
      } else {
        gider += amount;
        String catName = t['category_name'];
        expensesMap[catName] = (expensesMap[catName] ?? 0) + amount;
      }
    }

    totalGelirler.value = gelir;
    totalGiderler.value = gider;
    toplamBakiye.value = gelir - gider;
    categoryExpenses.value = expensesMap;
  }

  Future<void> addTransaction(double amount, int categoryId, String date, String? note) async {
    final transaction = FinanceTransaction(
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
    );
    await DatabaseHelper.instance.insertTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(int id, double amount, int categoryId, String date, String? note) async {
    final transaction = FinanceTransaction(
      id: id,
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
    );
    await DatabaseHelper.instance.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await loadTransactions();
  }

  Future<void> addCategory(String name, int type, String icon) async {
    final category = FinanceCategory(name: name, type: type, icon: icon);
    await DatabaseHelper.instance.insertCategory(category);
    await loadCategories();
  }

  Future<String?> deleteCategory(int id) async {
    int res = await DatabaseHelper.instance.deleteCategory(id);
    if (res == -1) {
      return 'Bu kategoriye ait işlemler var. Önce işlemleri silin.';
    }
    await loadCategories();
    return null;
  }
}
