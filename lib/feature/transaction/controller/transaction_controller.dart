import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';

class TransactionController extends GetxController {
  final RxList<Map<String, dynamic>> reportData = <Map<String, dynamic>>[].obs;
  final RxMap<String, List<Map<String, dynamic>>> expenseMapData = <String, List<Map<String, dynamic>>>{}.obs;
  final RxInt selectedIndex = 0.obs;
  final RxList<int> selectedExpenses = <int>[].obs;
  final RxBool isSelected = false.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString selectedCategory = "All".obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxMap<int, Map<String, dynamic>> reportDataCache = <int, Map<String, dynamic>>{}.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSelectionMode = false.obs;

  //final RxList<int> selectedExpenseIds = <int>[].obs;

  RxList expenseData = [].obs;

  @override
  void onInit() {
    super.onInit();
    reportData();
    expensesData();
    getReportData();
  }

  Future<void> fetchReportData(int reportId) async {
    if (!reportDataCache.containsKey(reportId)) {
      var data = await DBHelper.instance.fetchReportById(id: reportId);
      if (data != null) {
        reportDataCache[reportId] = data;
      }
    }
  }

  Future<void> expensesData() async {
    try {
      // Fetch expenses from database
      List<Map> fetchedData = await DBHelper.instance.readAllExpenses();

      // Create a new list to store updated items
      List<Map<String, dynamic>> updatedExpenses = [];

      for (var item in fetchedData) {
        // Create a copy of the item (to avoid modifying a read-only object)
        Map<String, dynamic> newItem = Map<String, dynamic>.from(item);

        if (newItem['report_id'] != null && newItem['report_id'].toString().isNotEmpty) {
          try {
            int reportId = int.tryParse(newItem['report_id'].toString()) ?? 0;

            // Fetch report name
            String reportName = await DBHelper.instance.fetchReportNameById(id: reportId);
            newItem['report_name'] = reportName;

            // Fetch report status
            String reportStatus = await DBHelper.instance.fetchReportStatusById(id: reportId);
            newItem['report_status'] = reportStatus;
          } catch (e) {
            //print("Error fetching report details for item: $newItem - Error: $e");
            newItem['report_name'] = "Unknown";
            newItem['report_status'] = "Unknown"; // Fallback value
          }
        } else {
          newItem['report_name'] = "No Report";
          newItem['report_status'] = "No Status"; // Handle empty report_id
        }

        updatedExpenses.add(newItem); // Add updated item to new list
      }

      // Update the observable list (RxList)
      expenseData.value = updatedExpenses;
      //print("Updated Expense Data: $expenseData");

      // Group expenses by formatted month-year
      Map<String, List<Map<String, dynamic>>> groupedData = {};

      for (var item in expenseData) {
        if (item['date'] != null && item['date'].isNotEmpty) {
          try {
            String date = item['date'];
            String formattedDate = DateFormat("MMMM yyyy").format(DateFormat("dd.MM.yyyy").parse(date));

            if (!groupedData.containsKey(formattedDate)) {
              groupedData[formattedDate] = [];
            }
            groupedData[formattedDate]!.add(item);
          } catch (e) {
            //print("Error parsing date for item: $item - Error: $e");
          }
        } else {
          //print("Skipping item with null/empty date: $item");
        }
      }

      expenseMapData.value = groupedData;
      update();

      //print("Grouped Expense Data: $expenseMapData");
    } catch (e) {
      //print("Error fetching expenses: $e");
    }
  }

  Future<void> getReportData() async {
    try {
      List<Map<dynamic, dynamic>> reports = await DBHelper.instance.readAllReports();
      reportData.assignAll(reports as Iterable<Map<String, dynamic>>);
      // print("Fetched Reports: ${reportData.length} items");
    } catch (e) {
      // print("Error fetching reports: $e");
    }
    expensesData();
    update();
  }

  void filterReports(String query) {
    if (query.isEmpty) {
      reportData.assignAll(reportData);
    } else {
      reportData.assignAll(
        reportData.where((report) => report['report_name'].toString().toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void selectCategory(int index, String category) {
    selectedIndex.value = index;
    selectedCategory.value = category;
  }

  Map<String, List<Map<String, dynamic>>> getFilteredExpenses() {
    String query = searchQuery.value.toLowerCase();

    Map<String, List<Map<String, dynamic>>> filteredData = {};

    expenseMapData.forEach((month, expenses) {
      List<Map<String, dynamic>> filteredList =
          expenses.where((item) {
            bool matchesSearch = query.isEmpty || (item['name']?.toString().toLowerCase() ?? '').contains(query);
            bool matchesCategory = selectedCategory.value == "All" || item['category_name'] == selectedCategory.value;
            bool matchesDate = true;

            if (startDate.value != null && endDate.value != null) {
              try {
                DateTime expenseDate = DateFormat("dd.MM.yyyy").parse(item['date']);
                DateTime start = startDate.value!;
                DateTime end = endDate.value!;
                // Check if expenseDate is within start and end (inclusive)
                matchesDate =
                    (expenseDate.isAfter(start.subtract(Duration(days: 1))) &&
                        (expenseDate.isBefore(end.add(Duration(days: 1)))));
              } catch (e) {
                matchesDate = false;
              }
            }

            return matchesSearch && matchesCategory && matchesDate;
          }).toList();

      if (filteredList.isNotEmpty) {
        filteredData[month] = filteredList;
      }
    });

    return filteredData;
  }

  Future<void> deleteExpensesByIds(List<int> expenseIds) async {
    for (int id in expenseIds) {
      await DBHelper.instance.deleteExpense(id: id);
    }
    expensesData();
    update();
  }

  void select(bool value) {
    isSelected.value = value;
    update();
  }

  void toggleSelection(int expenseId) {
    if (selectedExpenses.contains(expenseId)) {
      selectedExpenses.remove(expenseId);
    } else {
      selectedExpenses.add(expenseId);
    }
    // Update selection mode status
    if (selectedExpenses.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  void enterSelectionMode() {
    isSelectionMode.value = true;
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedExpenses.clear();
  }
}

//
// void toggleExpenseSelection(int expenseId) {
//   if (selectedExpenses.contains(expenseId)) {
//     selectedExpenses.remove(expenseId);
//   } else {
//     selectedExpenses.add(expenseId);
//   }
// }
