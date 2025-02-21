import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  // State variables
  var selectedIndex = 0.obs;
  var isSelected = false.obs;
  var selectedExpenses = <int>[].obs;
  var reportDataCache = <int, Map<String, dynamic>>{}.obs;
  var searchController = TextEditingController();
  var selectedCategory = "All".obs;
  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);
  var filteredData = <String, List<Map<String, dynamic>>>{}.obs;
  var categoryData = [].obs;
  var expenseMapData = <String, List<Map<String, dynamic>>>{}.obs;
  var reportData = [].obs;

  @override
  // void onInit() {
  //   super.onInit();
  //   fetchInitialData();
  // }

  // Fetch initial data
  // Future<void> fetchInitialData() async {
  //   await summaryData();
  //   await expensesData();
  //   await getReportData();
  //   await tabsData();
  // }

  // Fetch summary data
  Future<void> summaryData() async {
    // Implement your logic here
  }

  // Fetch expenses data
  // Future<void> expensesData() async {
  //   var data = await DBHelper.instance.fetchExpenses();
  //   expenseMapData.assignAll(_groupExpensesByMonth(data));
  //   filterReports();
  // }
  //
  // // Fetch report data
  // Future<void> getReportData() async {
  //   var data = await DBHelper.dbHelper.fetchReports();
  //   reportData.assignAll(data);
  // }
  //
  // // Fetch tabs data
  // Future<void> tabsData() async {
  //   var data = await DBHelper.dbHelper.getCategoryDB();
  //   categoryData.assignAll(data);
  // }

  // Group expenses by month
  Map<String, List<Map<String, dynamic>>> _groupExpensesByMonth(List<Map<String, dynamic>> expenses) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var expense in expenses) {
      String date = expense['date'];
      DateTime parsedDate = DateFormat("dd.MM.yyyy").parse(date);
      String month = DateFormat("MMMM yyyy").format(parsedDate);
      if (!groupedData.containsKey(month)) {
        groupedData[month] = [];
      }
      groupedData[month]!.add(expense);
    }
    return groupedData;
  }

  // Filter reports based on search query
  void filterReports() {
    String query = searchController.text.toLowerCase();
    filteredData.clear();

    expenseMapData.forEach((month, expenses) {
      List<Map<String, dynamic>> filteredList = expenses.where((item) {
        bool matchesSearch = query.isEmpty || item['name'].toLowerCase().contains(query);
        bool matchesCategory = selectedCategory.value == "All" || item['category_name'] == selectedCategory.value;
        bool matchesDate = true;
        if (startDate.value != null && endDate.value != null) {
          DateTime expenseDate = DateFormat("dd.MM.yyyy").parse(item['date']);
          matchesDate = expenseDate.isAfter(startDate.value!) && expenseDate.isBefore(endDate.value!);
        }
        return matchesSearch && matchesCategory && matchesDate;
      }).toList();
      if (filteredList.isNotEmpty) {
        filteredData[month] = filteredList;
      }
    });
  }

  // Select category
  void selectCategory(int index, String category) {
    selectedIndex.value = index;
    selectedCategory.value = category;
    filterReports();
  }

  // Toggle expense selection
  void toggleExpenseSelection(int expenseId) {
    if (selectedExpenses.contains(expenseId)) {
      selectedExpenses.remove(expenseId);
    } else {
      selectedExpenses.add(expenseId);
    }
  }

  // Delete selected expenses
  // Future<void> deleteExpensesByIds(List<int> ids) async {
  //   for (var id in ids) {
  //     await DBHelper.dbHelper.deleteExpenseById(id);
  //   }
  //   await expensesData();
  //   selectedExpenses.clear();
  // }
  //
  // // Fetch report data by ID
  // Future<void> fetchReportData(int reportId) async {
  //   if (!reportDataCache.containsKey(reportId)) {
  //     var data = await DBHelper.dbHelper.fetchReportById(id: reportId);
  //     if (data != null) {
  //       reportDataCache[reportId] = data;
  //     }
  //   }
  // }
}