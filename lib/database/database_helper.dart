import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path_provider/path_provider.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class DatabaseHelper {
  static const _databaseName = "FinanceDB_v2.db";
  static const _databaseVersion = 2;

  static const tableCategories = 'categories';
  static const tableTransactions = 'transactions';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await openDatabase(
        _databaseName, 
        version: _databaseVersion, 
        onCreate: _onCreate,
      );
    } else {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      return await openDatabase(
        path, 
        version: _databaseVersion, 
        onCreate: _onCreate,
      );
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type INTEGER NOT NULL,
        icon TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTransactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (category_id) REFERENCES $tableCategories (id)
      )
    ''');

    await db.insert(tableCategories, {'name': 'Maaş', 'type': 1, 'icon': 'attach_money'});
    await db.insert(tableCategories, {'name': 'Yatırım', 'type': 1, 'icon': 'trending_up'});
    await db.insert(tableCategories, {'name': 'Market', 'type': 0, 'icon': 'shopping_cart'});
    await db.insert(tableCategories, {'name': 'Kira', 'type': 0, 'icon': 'home'});
    await db.insert(tableCategories, {'name': 'Faturalar', 'type': 0, 'icon': 'receipt'});
    await db.insert(tableCategories, {'name': 'Ulaşım', 'type': 0, 'icon': 'directions_car'});
  }

  Future<int> insertCategory(FinanceCategory category) async {
    Database db = await instance.database;
    return await db.insert(tableCategories, category.toMap());
  }

  Future<List<FinanceCategory>> getCategories() async {
    Database db = await instance.database;
    var res = await db.query(tableCategories);
    return res.isNotEmpty ? res.map((c) => FinanceCategory.fromMap(c)).toList() : [];
  }

  Future<int> deleteCategory(int id) async {
    Database db = await instance.database;
    // Check if category is used
    var res = await db.query(tableTransactions, where: 'category_id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return -1; // Cannot delete, transactions exist
    }
    return await db.delete(tableCategories, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertTransaction(FinanceTransaction transaction) async {
    Database db = await instance.database;
    return await db.insert(tableTransactions, transaction.toMap());
  }

  Future<int> updateTransaction(FinanceTransaction transaction) async {
    Database db = await instance.database;
    return await db.update(tableTransactions, transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete(tableTransactions, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    Database db = await instance.database;
    return await db.rawQuery('''
      SELECT t.*, c.name as category_name, c.type as category_type, c.icon as category_icon
      FROM $tableTransactions t
      JOIN $tableCategories c ON t.category_id = c.id
      ORDER BY t.date DESC
    ''');
  }
}
