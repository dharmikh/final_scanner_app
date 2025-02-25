import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  Future<Database> _initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "scanner.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE category (id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, image TEXT)");
        await db.execute(
            "CREATE TABLE expense (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price TEXT, date TEXT, currency TEXT, category_name TEXT, category_image TEXT, description TEXT, report_id TEXT, status TEXT)");
        await db.execute(
            "CREATE TABLE report (id INTEGER PRIMARY KEY AUTOINCREMENT, report_name TEXT, client_name TEXT, report_description TEXT, report_status TEXT, report_status_image TEXT, report_date TEXT)");

        await db.insert("category", {"category": "All", "image": "😊"});
      },
    );
  }

  /// ============================ CATEGORY METHODS ============================

  Future<void> insertCategory({required String category, required String image}) async {
    final db = await database;
    await db.insert("category", {"category": category, "image": image});
  }

  Future<List<Map>> readCategories() async {
    final db = await database;
    return await db.rawQuery("SELECT * FROM category");
  }

  Future<void> updateCategory({required int id, required String category, required String image}) async {
    final db = await database;
    await db.update("category", {"category": category, "image": image}, where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteCategory({required int id}) async {
    final db = await database;
    await db.delete("category", where: "id = ?", whereArgs: [id]);
  }

  /// ============================ EXPENSE METHODS ============================

  Future<void> insertExpense({
    required String name,
    required String price,
    required String date,
    required String currency,
    required String categoryName,
    required String categoryImage,
    String? status,
    String? reportId,
    required String description,
  }) async {
    final db = await database;
    await db.insert("expense", {
      "name": name,
      "price": price,
      "date": date,
      "currency": currency,
      "category_name": categoryName,
      "category_image": categoryImage,
      "description": description,
      "status": status ?? "",
      "report_id": reportId ?? "",
    });
  }

  Future<List<Map>> readAllExpenses() async {
    final db = await database;
    return await db.rawQuery("SELECT * FROM expense");
  }

  Future<List<Map<String, dynamic>>> readExpensesByReport({required String reportId}) async {
    final db = await database;
    return await db.rawQuery("SELECT * FROM expense WHERE report_id = ?", [reportId]);
  }

  Future<List<Map<String, dynamic>>> readExpensesByCategory({required String categoryName}) async {
    final db = await database;
    return await db.rawQuery("SELECT * FROM expense WHERE category_name = ?", [categoryName]);
  }

  Future<void> updateExpense({
    required int id,
    required String name,
    required String price,
    required String date,
    required String currency,
    required String categoryName,
    required String categoryImage,
    required String description,
  }) async {
    final db = await database;
    await db.update(
      "expense",
      {
        "name": name,
        "price": price,
        "date": date,
        "currency": currency,
        "category_name": categoryName,
        "category_image": categoryImage,
        "description": description
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateExpenseReportData({required int id, required int reportId, required String status}) async {
    final db = await database;
    await db.update(
      "expense",
      {
        "report_id": reportId,
        "status": status,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteExpense({required int id}) async {
    final db = await database;
    await db.delete("expense", where: "id = ?", whereArgs: [id]);
  }

  /// ============================ REPORT METHODS ============================

  Future<void> insertReport({
    required String reportName,
    required String reportClientName,
    required String reportDescription,
    required String reportStatus,
    required String reportStatusImage,
    required String date,
  }) async {
    final db = await database;
    await db.insert("report", {
      "report_name": reportName,
      "client_name": reportClientName,
      "report_description": reportDescription,
      "report_status": reportStatus,
      "report_status_image": reportStatusImage,
      "report_date": date,
    });
  }

  Future<List<Map>> readReportsByStatus({required String reportStatus}) async {
    final db = await database;
    return await db.rawQuery("SELECT * FROM report WHERE report_status = ?", [reportStatus]);
  }

  Future<Map<String, dynamic>?> fetchReportById({required int id}) async {
    final db = await database;
    List<Map<String, dynamic>> dataList = await db.rawQuery("SELECT * FROM report WHERE id = ?", [id]);
    return dataList.isNotEmpty ? dataList.first : null;
  }

  Future<List<Map>> readAllReports() async {
    final db = await database;
    return await db.rawQuery("SELECT * FROM report");
  }

  Future<void> updateReport({
    required int id,
    required String reportName,
    required String clientName,
    required String description,
    required String date,
    required String status,
    required String statusImage,
  }) async {
    final db = await database;
    await db.update(
      "report",
      {
        "report_name": reportName,
        "client_name": clientName,
        "report_status": status,
        "report_status_image": statusImage,
        "report_description": description,
        "report_date": date,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteReport({required int id}) async {
    final db = await database;
    await db.delete("report", where: "id = ?", whereArgs: [id]);
  }
}
