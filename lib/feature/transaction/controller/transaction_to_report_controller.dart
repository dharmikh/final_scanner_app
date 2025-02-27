import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportBottomSheetController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TransactionController transactionController = Get.find<TransactionController>();
  final ReportController reportController = Get.find<ReportController>();

  final filteredData = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> _originalData = [];

  final RxMap<String, List<Map<String, dynamic>>> filteredReports = <String, List<Map<String, dynamic>>>{}.obs;

  void initializeData(List<Map<String, dynamic>> data) {
    _originalData = data;
    groupAndFilterData(_originalData);
  }

  void groupAndFilterData(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var report in data) {
      String status = report['report_status'] ?? 'Other';
      if (!grouped.containsKey(status)) {
        grouped[status] = [];
      }
      grouped[status]!.add(report);
    }
    filteredReports.value = grouped;
  }

  void filterReports(String query) {
    if (query.isEmpty) {
      groupAndFilterData(_originalData);
    } else {
      List<Map<String, dynamic>> filtered =
          _originalData
              .where((report) => report['report_name'].toString().toLowerCase().contains(query.toLowerCase()))
              .toList();
      groupAndFilterData(filtered);
    }
  }

  Future<void> updateExpenseReport(int id, Map<String, dynamic> report) async {
    await DBHelper.instance.updateExpenseReportData(
      id: id,
      reportId: int.tryParse(report['id'].toString()) ?? 0,
      //status: report['report_status'] ?? "",
    );

    await Future.wait([
      reportController.reportData(),
      transactionController.expensesData(),
      reportController.getReportData(),
      reportController.fetchReportExpenses(id.toString()),
    ]);

    Get.back(); // Close the bottom sheet
    Get.snackbar(
      "Success",
      "Data Successfully Added: ${report['report_name'] ?? ""}",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> updateExpense(List<int> data, int reportId) async {
    for (int i = 0; i < data.length; i++) {
      await DBHelper.instance.updateExpenseReportData(reportId: reportId, id: data[i]);
    }
  }
}
