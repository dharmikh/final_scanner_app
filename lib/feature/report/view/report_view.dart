import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/custom_container.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/report/view/add_new_report.dart';
import 'package:final_scanner_app/feature/report/view/report_details_view.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  ReportController reportController = Get.put(ReportController());
  TransactionController transactionController = Get.put(TransactionController());

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  void fetchReports() async {
    await reportController.reportData();
    await reportController.getReportData();
    await reportController.fetchAmountData(); // Ensure total amount updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: reportController.searchController,
          onChanged: (value) => reportController.searchReports(value),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: AppString.searchData,
            hintStyle: GoogleFonts.poppins(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            suffixIcon:
                reportController.searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        reportController.searchController.clear();
                      },
                    )
                    : null,
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
      body: Obx(() {
        var reportsData = reportController.filteredReports;

        if (reportsData.isEmpty) {
          return Center(child: Text("No reports found"));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: reportsData.keys.length,
            itemBuilder: (context, index) {
              String key = reportsData.keys.elementAt(index);
              List<Map> reports = reportsData[key]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.manRope24600(text: key),
                      if (index == 0)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewReportView(reportPageStatus: "add")),
                            );
                          },
                          child: AppText.manRope14(text: AppString.addNewText, color: AppColor.primaryColor),
                        ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, i) {
                      Map report = reports[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomBorderContainer(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ReportDetailView(
                                      id: report['id'] ?? 0,
                                      amount: report["total"].toStringAsFixed(2),
                                      cName: report["client_name"] ?? "",
                                      colorStatus: key,
                                      rName: report["report_name"] ?? "",
                                      status: report["report_status"] ?? "",
                                      statusImage: report["report_status_image"] ?? "",
                                      date: report["report_date"] ?? "",
                                      description: report["report_description"] ?? "",
                                    ),
                              ),
                            ).then((_) {
                              reportController.fetchAmountData();
                              reportController.getReportData();
                            });
                          },
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
                                    AppText.manRope24600(text: "\$${(report["total"] ?? 0.0).toStringAsFixed(2)}"),
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
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
