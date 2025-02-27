import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/report/view/add_new_report.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/app_string.dart';

class ReportBottomSheet extends StatefulWidget {
  final List? data;
  final String? text;
  final int id;
  final TextAlign? textAlign;

  const ReportBottomSheet({super.key, this.text, this.textAlign, this.data, required this.id});

  @override
  _ReportBottomSheetState createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  TextEditingController searchController = TextEditingController();
  TransactionController transactionController = Get.put(TransactionController());
  ReportController reportController = Get.put(ReportController());

  List filteredData = [];

  @override
  void initState() {
    transactionController.expensesData();
    reportController.reportData();
    filteredData = widget.data ?? [];
    super.initState();
  }

  void filterReports(String query) {
    if (query.isEmpty) {
      filteredData = widget.data ?? [];
    } else {
      filteredData =
          widget.data!
              .where((report) => report['report_name'].toString().toLowerCase().contains(query.toLowerCase()))
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.5,
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
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(right: 210),
                          child: AppText.manRope16(text: AppString.addReportText, color: AppColor.dark),
                        ),
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await DBHelper.instance.updateExpenseReportData(
                                    id: widget.id,
                                    reportId: int.tryParse(filteredData[index]['id'].toString()) ?? 0,
                                  );
                                  Get.snackbar(
                                    "Hello",
                                    "Data Successfully Added: ${filteredData[index]['report_name'] ?? ""}",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.black54,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 3),
                                  );
                                  await reportController.reportData();
                                  await transactionController.expensesData();
                                  await reportController.getReportData();
                                  await reportController.fetchReportExpenses(widget.id.toString());

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  height: 83,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      color:
                                          filteredData[index]['report_status'] == "Completed"
                                              ? AppColor.darkGreen
                                              : filteredData[index]['report_status'] == "Sent"
                                              ? AppColor.blueShad
                                              : AppColor.redColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.manRope24500(text: filteredData[index]['report_name'] ?? ""),
                                            AppText.manRope24500(text: "-165\$"),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText.manRope13(
                                              text: "${filteredData[index]['client_name'] ?? ""}",
                                              color: AppColor.greyColor100,
                                            ),
                                            AppText.manRope13(text: "1 Expense", color: AppColor.greyColor100),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewReportView()));
                          },
                          child: Container(
                            height: 56,
                            width: MediaQuery.sizeOf(context).height / 2.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColor.primaryColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText.manRope14(text: AppString.addNewReportText, color: AppColor.light),
                                SizedBox(width: 10),
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
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(width: 1, color: AppColor.greyColor50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(AppImages.addIcon),
              SizedBox(width: 10),
              Text(
                widget.text!,
                textAlign: widget.textAlign,
                style: GoogleFonts.manrope(color: AppColor.dark, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
