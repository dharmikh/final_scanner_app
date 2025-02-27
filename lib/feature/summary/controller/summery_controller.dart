import 'dart:math';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/feature/bottomNavigation/controller/bottom_navigation_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryController extends GetxController {
  TransactionController transactionController = Get.put(TransactionController());
  RxInt currentPage = 0.obs;
  RxString selectedMonth = ''.obs;
  RxDouble totalExpense = 0.0.obs;
  var result = <String, String>{}.obs;
  var expenseData = <Map<String, dynamic>>[].obs;

  Map<String, List<Map<String, dynamic>>> expenseMapData = {};

  @override
  void onInit() {
    super.onInit();
    final bottomController = Get.find<BottomNavigationController>();
    ever(bottomController.currentIndex, (index) {
      if (index == 1) {
        summaryData();
      }
    });
    if (bottomController.currentIndex.value == 1) {
      summaryData();
    }
    transactionController.expensesData();
    summaryData();
  }

  // List of months for pagination
  final List<String> orderedMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  // Computed property for paginated months
  List<String> get currentPageMonths {
    int start = currentPage.value * 4;
    int end = start + 4;
    return orderedMonths.sublist(start, end > orderedMonths.length ? orderedMonths.length : end);
  }

  void nextPage() {
    if ((currentPage.value + 1) * 4 < orderedMonths.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  Future<void> selectMonthYear(BuildContext context) async {
    int selectedMonthValue = DateTime.now().month;
    int selectedYear = DateTime.now().year;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Month and Year"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<int>(
                value: selectedMonthValue,
                items: List.generate(12, (index) {
                  return DropdownMenuItem(value: index + 1, child: Text("${index + 1}"));
                }),
                onChanged: (int? value) {
                  if (value != null) {
                    selectedMonthValue = value;
                  }
                },
              ),
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(50, (index) {
                  int year = DateTime.now().year - 25 + index;
                  return DropdownMenuItem(value: year, child: Text("$year"));
                }),
                onChanged: (int? value) {
                  if (value != null) {
                    selectedYear = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                selectedMonth.value = DateFormat('MMMM').format(DateTime(selectedYear, selectedMonthValue));
                Get.back();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> summaryData() async {
    buildBarGroups();
    getMaxY();
    // Retrieve the expense data from the database.
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(await DBHelper.instance.readAllExpenses());
    if (data.isNotEmpty) {
      expenseData.assignAll(data);
    } else {
      expenseData.clear();
    }

    // Initialize the grouped data map with all months as keys.
    Map<String, List<Map<String, dynamic>>> groupedData = {for (var month in orderedMonths) month: []};

    // Group the expense data by month.
    for (var item in expenseData) {
      try {
        String dateStr = item['date'];
        // Parse the date from the expected format.
        DateTime parsedDate = DateFormat("dd.MM.yyyy").parse(dateStr);
        // Format the date to get the full month name.
        String formattedMonth = DateFormat("MMMM").format(parsedDate);
        // Add the item to the respective month list.
        groupedData[formattedMonth]?.add(item);
      } catch (e) {
        // Handle any parsing errors here.
        // print("Error parsing date for item: $item. Error: $e");
      }
    }

    // Update the reactive map.
    expenseMapData.assignAll(groupedData);
    // print(expenseMapData);

    // Set the selected month to the first month that has data, if not already set.
    if (expenseMapData.isNotEmpty && selectedMonth.value.isEmpty) {
      selectedMonth.value =
          expenseMapData.entries
              .firstWhere((entry) => entry.value.isNotEmpty, orElse: () => MapEntry(orderedMonths.first, []))
              .key;
    }

    // Calculate the grand total price across all expenses.
    totalExpense.value = expenseMapData.values
        .expand((transactions) => transactions)
        .fold(0.0, (sum, item) => sum + double.parse(item["price"].toString()));

  }

  void chengIndex() {
    final newResult = <String, String>{};

    List<Map<String, dynamic>> monthData = expenseMapData[selectedMonth.value] ?? [];
    Map<String, double> categoryTotals = {};

    for (var item in monthData) {
      String category = item['category_name'] ?? "Unknown";
      double price = double.tryParse(item['price'].toString()) ?? 0.0;
      categoryTotals[category] = (categoryTotals[category] ?? 0) + price;
    }

    totalExpense.value = categoryTotals.values.fold(0.0, (sum, price) => sum + price);

    if (totalExpense.value > 0) {
      newResult.addAll(
        categoryTotals.map((category, total) {
          double percentage = (total / totalExpense.value) * 100;
          return MapEntry(category, "%${percentage.toStringAsFixed(1)}");
        }),
      );
    }

    result.value = newResult;
    //print("Updated Pie Chart Data: $newResult");
  }

  String formatCategory(String category) {
    return category.toLowerCase().trim();
  }

  List<PieChartSectionData> getPieChartSections() {
    return result.entries.map((entry) {
      String category = formatCategory(entry.key);
      double value = double.tryParse(entry.value.replaceAll('%', '')) ?? 0.0;

      return PieChartSectionData(
        color: CategoryColorManager.getCategoryColor(category),
        value: value,
        showTitle: false,
        borderSide: BorderSide.none,
        radius: 60,
      );
    }).toList();
  }

  List<BarChartGroupData> buildBarGroups() {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < currentPageMonths.length; i++) {
      String month = currentPageMonths[i];

      // Fix: Ensure the key exists in the map
      if (!expenseMapData.containsKey(month) || expenseMapData[month] == null) {
        continue;
      }

      // Fix: Provide a default empty list if null
      totalExpense.value =
          expenseMapData[month]?.fold(0.0, (sum, expense) => sum! + (double.parse(expense['price']))) ?? 0.0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: totalExpense.value,
              color: AppColor.primaryColor,
              width: 15,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  double getMaxY() {
    final currentValues = buildBarGroups().expand((group) => group.barRods).map((rod) => rod.toY).toList();

    if (currentValues.isEmpty) return 100;
    return currentValues.reduce((max, value) => value > max ? value : max) * 1;
  }
}

class CategoryColorManager {
  static final Map<String, Color> colorMap = {};

  static Color getCategoryColor(String category) {
    if (!colorMap.containsKey(category)) {
      colorMap[category] = _getRandomColor();
    }
    return colorMap[category]!;
  }

  static Color _getRandomColor() {
    Random random = Random();
    return Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }
}



