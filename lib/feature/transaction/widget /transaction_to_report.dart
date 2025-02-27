import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/custom_container.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/report/view/add_new_report.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/transaction_to_report_controller.dart';

class DataBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>>? data;
  final List<int>? expenseIds;

  final int id;

  const DataBottomSheet({super.key, this.data, required this.id, this.expenseIds});

  @override
  _DataBottomSheetState createState() => _DataBottomSheetState();
}

class _DataBottomSheetState extends State<DataBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  final ReportController reportController = Get.put(ReportController());
  final ReportBottomSheetController reportBottomSheetController = Get.put(ReportBottomSheetController());
  final TransactionController transactionController = Get.put(TransactionController());

  late List<Map<String, dynamic>> filteredData;
  late List<Map<String, dynamic>> allReports;

  @override
  void initState() {
    super.initState();
    allReports = widget.data ?? [];
    filteredData = allReports;
  }

  void filterReports(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = allReports;
      } else {
        filteredData =
            allReports
                .where((report) => report['report_name'].toString().toLowerCase().contains(query.toLowerCase()))
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var reportsData = reportController.filteredReports;
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            color: AppColor.light,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 56,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColor.dark),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AppText.manRope16(text: AppString.addReportText, color: AppColor.dark),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search Reports",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: filterReports,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: reportsData.keys.length,
                    itemBuilder: (context, index) {
                      String key = reportsData.keys.elementAt(index);
                      List<Map> reports = reportsData[key]!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reports.length,
                        itemBuilder: (context, i) {
                          Map report = reports[i];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                //print(report['id']);
                                print(widget.expenseIds);

                                reportBottomSheetController.updateExpense(widget.expenseIds ?? [], report["id"]);

                                await reportController.reportData();
                                await transactionController.expensesData();
                                Get.back();
                                widget.expenseIds!.clear();
                              },

                              child: CustomBorderContainer(
                                borderColor:
                                    key == "Completed"
                                        ? AppColor.darkGreen
                                        : key == "Sent"
                                        ? AppColor.blueShad
                                        : AppColor.redColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText.manRope24600(text: (report["report_name"] ?? "No Name")),
                                          AppText.manRope24600(
                                            text: "\$${(report["total"] ?? 0.0).toStringAsFixed(2)}",
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText.manRope13(
                                            text: "${report["client_name"] ?? "No client"}",
                                            color: AppColor.greyColor100,
                                          ),
                                          AppText.manRope13(
                                            text: "${report["expense_count"] ?? 0} Expense",
                                            color: AppColor.greyColor100,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => NewReportView());
                  },
                  child: Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColor.primaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.manRope14(text: AppString.addNewReportText, color: AppColor.light),
                        const SizedBox(width: 10),
                        Image.asset(AppImages.addIcon, color: AppColor.light),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
