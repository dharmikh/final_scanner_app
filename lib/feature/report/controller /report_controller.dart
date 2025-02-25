import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  TransactionController transactionController = Get.put(TransactionController());
  TextEditingController searchController = TextEditingController();
  RxMap<String, List<Map>> formattedStatusData = <String, List<Map>>{}.obs;
  RxList<String> reportStatus = ["Completed", "Sent", "Unsent"].obs;
  RxString searchQuery = "".obs;
  RxList reportIndex = [].obs;

  double calculateTotalAmount() {
    double total = 0.0;
    reportExpenseMapData.forEach((month, expenses) {
      for (var expense in expenses) {
        total += double.tryParse(expense['price'].toString()) ?? 0.0;
      }
    });
    return total;
  }

  Future<void> reportData() async {
    Map<String, List<Map>> tempData = {};
    for (String status in reportStatus) {
      List<Map> reports = await DBHelper.instance.readReportsByStatus(reportStatus: status);
      tempData[status] = reports;
    }

    formattedStatusData.assignAll(tempData);
  }

  void searchReports(String query) {
    searchQuery.value = query.toLowerCase();
    update();
  }

  Map<String, List<Map>> get filteredReports {
    if (searchQuery.isEmpty) {
      return _addTotalToEachReport(formattedStatusData);
    }

    final filteredData = formattedStatusData.map((key, reports) {
      var filtered =
          reports.where((report) {
            return (report["report_name"] ?? "").toLowerCase().contains(searchQuery.value);
          }).toList();

      return MapEntry(key, filtered);
    })..removeWhere((key, value) => value.isEmpty);

    return _addTotalToEachReport(filteredData);
  }

  Map<String, List<Map>> _addTotalToEachReport(Map<String, List<Map>> data) {
    return data.map((key, reports) {
      return MapEntry(
        key,
        reports.map((report) {
          // Ensure expenses is a list
          List expenses = report["expenses"] is List ? report["expenses"] : [];
          int expenseCount = expenses.length;

          return {
            ...report,
            "total": report["total"] ?? 0,
            //"expense_count": RxInt(expenseCount), // Use RxInt
          };
        }).toList(),
      );
    });
  }

  RxList<Map<String, dynamic>> reportExpenses = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> reportExpenseMapData = <String, dynamic>{}.obs;
  RxMap<String, List<Map<String, dynamic>>> reportGroupedData = <String, List<Map<String, dynamic>>>{}.obs;

  Future<void> fetchReportExpenses(String reportId) async {
    try {
      reportGroupedData.clear();
      reportExpenseMapData.value = {};
      reportExpenses.value = [];

      List<Map<String, dynamic>> expenses = await DBHelper.instance.readExpensesByReport(reportId: reportId);

      if (expenses.isEmpty) return;

      for (var item in expenses) {
        if (!item.containsKey('date') || item['date'] == null) continue;

        try {
          String date = item['date'];
          String formattedDate = DateFormat("MMMM yyyy").format(DateFormat("dd.MM.yyyy").parse(date));

          reportGroupedData.value.putIfAbsent(formattedDate, () => []);
          reportGroupedData.value[formattedDate]!.add(item);
        } catch (e) {
          // Handle date parsing errors
        }
      }

      reportExpenseMapData.value = reportGroupedData.value;
      reportExpenses.value = expenses;
      print(reportGroupedData.values);
    } catch (e) {
      // Handle errors
    }
  }

  bool reportExists(String newReportName) {
    for (String key in filteredReports.keys) {
      List<Map> reports = filteredReports[key]!;
      for (Map report in reports) {
        if (report['report_name'] == newReportName) {
          return true; // Duplicate found
        }
      }
    }
    return false;
  }

  RxList<Map> expenseData = <Map>[].obs;

  Future<void> getReportData() async {
    try {
      List<Map> reports = await DBHelper.instance.readAllExpenses();
      expenseData.assignAll(reports);
    } catch (e) {
      Text(e.toString());
    }
  }

  RxMap<int, Map<String, dynamic>> reportDataCache = <int, Map<String, dynamic>>{}.obs;

  Future<void> fetchReportData(int reportId) async {
    if (!reportDataCache.containsKey(reportId)) {
      var data = await DBHelper.instance.fetchReportById(id: reportId);
      if (data != null) {
        reportDataCache[reportId] = data;
        reportDataCache.refresh();
      }
    }
  }

  RxList expenseToRData = [].obs;
  RxList filteredExpenses = [].obs;

  Future<void> expensesToReportData() async {
    expenseToRData.value = await DBHelper.instance.readAllExpenses();
    filteredExpenses.value = expenseToRData.value;
    update();
  }

  void filterExpenses(String query) {
    if (query.isEmpty) {
      filteredExpenses.value = expenseToRData.value;
    } else {
      filteredExpenses.value =
          expenseToRData.value
              .where((report) => report['name'].toString().toLowerCase().contains(query.toLowerCase()))
              .toList();
    }
  }

  RxList totalReportPrice = [].obs;

  Future<void> fetchAmountData() async {
    await reportData();
    await transactionController.expensesData();

    List<int> idList = [];

    // Extract report IDs
    formattedStatusData.forEach((key, value) {
      if (value is List) {
        for (var item in value) {
          if (item is Map && item.containsKey("id")) {
            idList.add(item["id"]);
          }
        }
      }
    });

    Map<int, num> totalMap = {};
    Map<int, int> expenseCountMap = {}; // Store expense count per report

    for (int i = 0; i < idList.length; i++) {
      num totalPrice = 0;
      await fetchReportExpenses(idList[i].toString());

      int expenseCount = reportExpenses.value.length; // Get expense count

      for (var expense in reportExpenses.value) {
        totalPrice += num.tryParse(expense['price']?.toString() ?? '0') ?? 0;
      }

      totalMap[idList[i]] = totalPrice;
      expenseCountMap[idList[i]] = expenseCount; // Store expense count
    }

    formattedStatusData.updateAll((key, reports) {
      return reports.map((report) {
        int reportId = report["id"];
        return {
          ...report,
          "total": totalMap[reportId] ?? 0,
          // Wrap expense count in an RxInt for reactive UI updates
          "expense_count": RxInt(expenseCountMap[reportId] ?? 0),
        };
      }).toList();
    });
    print("Updated formattedStatusData: $formattedStatusData");
  }
}
